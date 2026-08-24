class ErlangLanguagePlatform < Formula
  desc "LSP server and CLI for the Erlang programming language"
  homepage "https://whatsapp.github.io/erlang-language-platform/"
  # We require the submodules, so we fetch via git
  url "https://github.com/WhatsApp/erlang-language-platform.git",
      tag:      "2026-08-10",
      revision: "81ddb608598ff652a44a362f7a65cf2516bf6d1e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/WhatsApp/erlang-language-platform.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ad391d900393c25caf48f2e470dc335f5108cd845a45efdf8f57d367e87ea4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20574935d89a229c0197046b9b02e4c7769dee68c6d138319a07d21c287144d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5402341a7bcdde555e295f4f64c99f346a74b63f83bb7f3654e028e2e97c5f3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "26bc1cbb9f6d29613e99c898512f0553b961ac58bc3c6c93ffb93ca4cdadd11c"
    sha256 cellar: :any,                 arm64_linux:   "05ad6aa17d87cca92348616e11462d600506a3d5d35ecf037b4bf567f2ba08eb"
    sha256 cellar: :any,                 x86_64_linux:  "b56acf483def3caa12fa96f3c0f973ee79d32b1ca5635445d79859edc86284dd"
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
