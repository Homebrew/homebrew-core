class ErlangLanguagePlatform < Formula
  desc "LSP server and CLI for the Erlang programming language"
  homepage "https://whatsapp.github.io/erlang-language-platform/"
  # We require the submodules, so we fetch via git
  url "https://github.com/WhatsApp/erlang-language-platform.git",
      tag:      "2026-11-20",
      revision: "f299499f3e7eeef7b91be3f96e846076083d590f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/WhatsApp/erlang-language-platform.git", branch: "main"

  bottle do
    manifest_sha256 "7efca6c3533f4f1c7e11de818309e1938a4d8df6efc491684ee75cd64020cdab"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72ae3434c4b54e7f13684d03c0f3fb3500e7446d62865bb4c28c102f30efdf83"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e24f1a9982a84bffd91dba09d740ac53839dd57a7bddab5e3ac91d9d586263d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2642938f4078f1ed05c55765290b42501c4e8469755cbd2442ec8ddd5c2c960"
    sha256 cellar: :any,                 arm64_linux:       "1feb00c5219c6f40440974f449c7febe08cd988a161690165c59173dce3f3179"
    sha256 cellar: :any,                 x86_64_linux:      "a62deb608eb31828f9c73c9f6b31490c0ad3a51841cbbb25d2946fc471753f6b"
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
    bin.env_script_all_files libexec, PATH: "#{formula_opt_bin("erlang")}:${PATH}"
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
    output = shell_output("#{bin}/elp lint")

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
