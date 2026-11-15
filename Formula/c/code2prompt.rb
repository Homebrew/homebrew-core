class Code2prompt < Formula
  desc "CLI tool to convert your codebase into a single LLM prompt"
  homepage "https://code2prompt.dev/"
  url "https://static.crates.io/crates/code2prompt/code2prompt-4.3.0.crate"
  sha256 "990ebe1d34dec07580dd23e4097423989f0bd6c8d4f4de9d47c0ae77a0c2c732"
  license "MIT"
  head "https://github.com/mufeedvh/code2prompt.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2d50d0a0b2e6b17376d54114227d8faeef934990586dac85d642728a6bb81c08"
    sha256 cellar: :any, arm64_tahoe:       "1d2ef2f2614821901b55959c0d5202f8baba4b395370b7c2ef5ee13fdec9eaee"
    sha256 cellar: :any, arm64_sequoia:     "6c44b6490c5b23ff62845d1868308168cb2849c09067d4c59bfc63aed7988f0a"
    sha256 cellar: :any, arm64_linux:       "36770c0a2f2e665fdbacbb5034679524ddce920d225cb6b19a421f4aa306580d"
    sha256 cellar: :any, x86_64_linux:      "cb845d3dc985f9bd98e60ad2b34bb24cacbfe05e6b919283bc42b2f3ed644f4e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    path = build.head? ? "crates/code2prompt" : "."
    system "cargo", "install", *std_cargo_args(path:)
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/code2prompt --version")

    (testpath/"test.py").write <<~PYTHON
      def hello_world():
          print("Hello, world!")
    PYTHON

    system bin/"code2prompt", "--no-clipboard", "--output-file", "test.json", "--output-format", "json", "test.py"
    json_output = (testpath/"test.json").read
    assert_match "ChatGPT models, text-embedding-ada-002", JSON.parse(json_output)["model_info"]

    [
      formula_opt_lib("openssl@4")/shared_library("libssl"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"code2prompt", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
