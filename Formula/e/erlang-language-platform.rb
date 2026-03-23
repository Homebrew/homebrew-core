class ErlangLanguagePlatform < Formula
  desc "LSP server and CLI for the Erlang programming language"
  homepage "https://whatsapp.github.io/erlang-language-platform/"
  # We require the submodules, so we fetch via git
  url "https://github.com/WhatsApp/erlang-language-platform.git",
      tag:      "2026-02-27",
      revision: "3a65019ef3b85a7b0f58c998f5d5a545d7394b15"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/WhatsApp/erlang-language-platform.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5a498d14918e123192b9ab0f2da6a88b23118bd0f04889742fb6afcb7f843e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3a78107e784f20cfd77f2a7ecb8c71fa116059764cf7d0c875e85fb408e37ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e7e2d78e18a19f5d5ca4dea447335b282436ccc00e65f057beeb8524f88c81a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9984214c9bd155fad1fb9b28664819abfdfd18dfe64863c6571d0cd0ba92600"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26e2191aaf4cfac4d1bf79c62c1181b5c70f81bfaf37abec5bccfa9277ef4d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb4947af38046be0fdd8a8424f68448c1ed0f42f8ffd5609622b5ce3be67495b"
  end

  depends_on "rust" => :build
  depends_on "sbt" => :build
  depends_on "scala" => :build
  depends_on "erlang"
  depends_on "openjdk"
  depends_on "rebar3"

  def install
    # Build eqwalizer and copy the relevant artifacts to the buildpath
    cd "eqwalizer/eqwalizer" do
      system "sbt", "assembly"
      cp Dir["target/scala-*/eqwalizer.jar"].first, buildpath/"eqwalizer.jar"
    end
    # Build ELP, using the generated artifacts
    ENV["ELP_EQWALIZER_PATH"] = buildpath/"eqwalizer.jar"
    ENV["EQWALIZER_DIR"] = "eqwalizer/eqwalizer_support"
    # The manifest is a workspace manifest, there's nothing "installable"
    build_args = ["build", "--release"]
    system "cargo", *build_args, *std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] }
    bin.install "target/release/elp"
    generate_completions_from_executable(bin/"elp", "generate-completions")
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
    output = shell_output("#{bin}/elp lint my_module.erl")

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
