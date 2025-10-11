class ErlangLanguagePlatform < Formula
  desc "LSP server and CLI for the Erlang programming language"
  homepage "https://whatsapp.github.io/erlang-language-platform/"
  url "https://github.com/WhatsApp/erlang-language-platform/archive/refs/tags/2025-09-11.tar.gz"
  sha256 "7f0e9d8fb34258ffc9689a784eadbcdaa1ded6f6d91bee6689074de08b3f5bc8"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build
  depends_on "sbt" => :build
  depends_on "scala" => :build
  depends_on "erlang" # Requires Erlang/OTP >= 26.2
  depends_on "openjdk"
  depends_on "rebar3"

  # eqwalizer is an Erlang type checker.
  # Despite living in a separate repository under the same organization,
  # it is distributed via the ELP executable.
  # See: https://whatsapp.github.io/erlang-language-platform/docs/get-started/install/#from-source
  resource "eqwalizer" do
    url "https://github.com/WhatsApp/eqwalizer.git",
        revision: "c4d1098174cec06bd124855f3a28dfd6eda0a581"
  end

  def install
    # Build eqwalizer and copy the relevant artifacts to the buildpath
    resource("eqwalizer").stage do
      cd "eqwalizer" do
        system "sbt", "assembly"
        cp Dir["target/scala-*/eqwalizer.jar"].first, buildpath/"eqwalizer.jar"
      end
      buildpath.install "eqwalizer_support"
    end

    # Build ELP, using the generated artifacts
    ENV["ELP_EQWALIZER_PATH"] = buildpath/"eqwalizer.jar"
    ENV["EQWALIZER_DIR"] = buildpath/"eqwalizer_support"
    # Cannot use the standard cargo arguments for a few reasons:
    # - The manifest is a workspace manifest, there's nothing "installable"
    # - The public version of the lock file uses the official tree-sitter crate, instead of
    #   an internal fork. This causes a change in the lock file, not allowing us to use --locked
    build_args = ["build", "--release"]
    system "cargo", *build_args, *std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] || arg["--locked"] }
    bin.install "target/release/elp"
    generate_completions_from_executable(bin/"elp", "generate-completions", shells: [:bash, :fish, :zsh])
  end

  test do
    # Test version
    assert_match version.to_s, shell_output("#{bin}/elp version")

    # Test ELP diagnostic detection
    (testpath/"my_module.erl").write <<~ERL
      -module(my_module).
      -moduledoc """
      This is a test module.
      """.
      -export([test_function/0]).

      -doc """
      This is a test function
      """.
      test_function() ->
          X = 42,
          ok.
    ERL

    # Run ELP lint to detect diagnostics
    output = shell_output("#{bin}/elp lint my_module.erl", 101)

    # Verify that ELP detected the unused variable diagnostic
    assert_match("variable 'X' is unused", output)

    # Test Eqwalizer integration
    ENV["JAVA_HOME"] = Language::Java.java_home

    (testpath/"my_typed_module.erl").write <<~ERL
      -module(my_typed_module).
      -export([test_function/0]).

      -spec test_function() -> string().
      test_function() ->
          42.
    ERL

    # Run ELP lint to detect diagnostics
    output = shell_output("#{bin}/elp eqwalize my_typed_module")

    # Verify that ELP detected the type mismatch
    assert_match("incompatible_types", output)
  end
end
