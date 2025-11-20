class ErlangLanguagePlatform < Formula
  desc "LSP server and CLI for the Erlang programming language"
  homepage "https://whatsapp.github.io/erlang-language-platform/"
  # We require the submodules, so we fetch via git
  url "https://github.com/WhatsApp/erlang-language-platform.git",
      tag:      "2025-11-04",
      revision: "9e99f9644ed76baa13ae2396a6c325b65f0b099a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/WhatsApp/erlang-language-platform.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ea1cb6a202161f728a8610bafe96d12ca0cb28af799e2fcd08067f2f691ceca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3340ffdf7d564b1a6b1f8bc9aa68db1173cb41ed01fa931d69daa0704a5e8836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f227be4bb28337c295244928149443f466fd005010f633da9b8dbbc3f20093ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "231d06bdc29e136f84057ea5f361c7f66d84faf77679c18d9d348584213eb00f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e016a10f3b0f0ec5c56550f66ae943620c0264a4890e0138c8b1d6a35ceee85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "950d85b6bd7a10767160a2f6079d00455048464ea913e5aca623bf4eacd6af03"
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
