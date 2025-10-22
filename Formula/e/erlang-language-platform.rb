class ErlangLanguagePlatform < Formula
  desc "LSP server and CLI for the Erlang programming language"
  homepage "https://whatsapp.github.io/erlang-language-platform/"
  # We require the submodules, so we fetch via git
  url "https://github.com/WhatsApp/erlang-language-platform.git",
      tag:      "2025-10-21",
      revision: "d6f2636f015069ed32137a42f99b9b2ecbaa35a9"
  license any_of: ["Apache-2.0", "MIT"]
  head "github.com/WhatsApp/erlang-language-platform.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74b858f39da070d67f5606088a502bfe5eceefe97f75a179eb7d53005f615517"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec1cdb61be4218490856f31cc21913fbe45574bd216e720b9a2bfb6aacff9f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b377631223b13b28a3704de569f2ac75718a842b7cb54776c2fa85002a0eeb15"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb4f04040b91c7b1f96ac6e0231f4f3048cffa976d82abdd4b3dc1514a8c6d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f737b67821c32935f8059b26fba18c8729a36aa1fd389166cd351af9b9fedaaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89df1cb575a38666c08a9d17f5ac51e20dcffa9d9745483bffa27b7c5e90705a"
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
