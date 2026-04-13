class Code2prompt < Formula
  desc "CLI tool to convert your codebase into a single LLM prompt"
  homepage "https://code2prompt.dev/"
  url "https://github.com/mufeedvh/code2prompt/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "de0fe811914bee2d03a0025e734d702d1cb50472dd75c42017cc65ac9435e481"
  license "MIT"
  head "https://github.com/mufeedvh/code2prompt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "14aa4f7a6f013ffc948306bbe0210b951ccc0523d78ebd1b1c5ef0a36c08f1c2"
    sha256 cellar: :any,                 arm64_sequoia: "e7bdea92a684ab0483bad093e9aa554d2df195d77eb2676f1f469b71c524a7ed"
    sha256 cellar: :any,                 arm64_sonoma:  "d25ee8e05d2016985e5ebcf1befe31d2ddbd9b67fc482ed9d00a39f0e61ff04b"
    sha256 cellar: :any,                 sonoma:        "48fb47f8ece13be5215c64d39b3b641498fe3f9e46c901dedaa2123adddd9361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8133b94fe8d8ff29a3b14dfadfd7c333b40f811193d0a0cc8fa81805e8851133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "901f372469f56db97e43cb4ad0beff306ed34532bb7728be03d71cfd19ca8fa1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/code2prompt")
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
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"code2prompt", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
