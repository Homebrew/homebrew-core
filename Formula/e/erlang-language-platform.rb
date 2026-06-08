class ErlangLanguagePlatform < Formula
  desc "LSP server and CLI for the Erlang programming language"
  homepage "https://whatsapp.github.io/erlang-language-platform/"
  # We require the submodules, so we fetch via git
  url "https://github.com/WhatsApp/erlang-language-platform.git",
      tag:      "2026-02-27",
      revision: "3a65019ef3b85a7b0f58c998f5d5a545d7394b15"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/WhatsApp/erlang-language-platform.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8576d3b5737facfdf4eb2337763f3e161a5ed02d5072fb80d674697f3d301b3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "951b548a94eddf55a00d497154356f0dd536bd5f6c743982b0b8171cf4cf9f77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf6944548b7f14fbfb4e420f593e3279e2b89496dc2273859f5ce04c39afcc75"
    sha256 cellar: :any_skip_relocation, sonoma:        "89e23670e8fd9e570690e6b893f6240b76ec74c5a7487470a6c3e029786a59b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efc14ca44ba1e1fd97f240e33f5b143589d97d8a19a11be57049008cbb5cba99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d73ccda29804be2a0d64c887a20a7e6210a2320efe97a158ba13dda52ce61474"
  end

  depends_on "rust" => :build
  depends_on "sbt" => :build
  depends_on "scala" => :build
  depends_on "erlang@28"
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
    bin.env_script_all_files libexec, PATH: "#{Formula["erlang@28"].opt_bin}:${PATH}"
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
