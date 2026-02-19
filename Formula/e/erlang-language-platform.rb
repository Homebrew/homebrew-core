class ErlangLanguagePlatform < Formula
  desc "LSP server and CLI for the Erlang programming language"
  homepage "https://whatsapp.github.io/erlang-language-platform/"
  # We require the submodules, so we fetch via git
  url "https://github.com/WhatsApp/erlang-language-platform.git",
      tag:      "2026-02-10",
      revision: "f028b38661b614d8546a8f51928cba9ab7efd79e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/WhatsApp/erlang-language-platform.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd3cce12947adc9dd78f713905c964610394fe89f4987e7746dd44e035e69b13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7ff80ebf56f48615e44bd44f731f62e752bc8096d940b663818b5b8c6775e1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f26e1f3d5cdd37b9f4848e25cd07f81b6321245031b594e6410ff5c40e1d15c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "65e6f6d577d6e59fd28bcbcab378c36fa51fb494700416b8322cb2d2df1dffe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eacbd125f6bcbf61714904caa86cbdc41c325d4c90decb54bf261092f55ad5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f96d3c51673a03d136894365145390c575145483296cb36f80b116e34bb6b7b4"
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
