class Code2prompt < Formula
  desc "CLI tool to convert your codebase into a single LLM prompt"
  homepage "https://code2prompt.dev/"
  url "https://github.com/mufeedvh/code2prompt/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "8d5958a7ad8f906c6643bdf541404c008d89be6f26102a29f2c4f485a42b911d"
  license "MIT"
  head "https://github.com/mufeedvh/code2prompt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37fa9bb30d4a91b9dd4f6df0ab2195f46d7d4c46899b9a7464b129ca3fbfc66f"
    sha256 cellar: :any,                 arm64_sequoia: "009975fe56d00c4fe9971398f237d43fb808bbe5af442f64e78e366acaced0d6"
    sha256 cellar: :any,                 arm64_sonoma:  "6a272bc9d14e3f08ebbeeb7252ab74ada3e3b9ff0910dd8df2f984ad37837325"
    sha256 cellar: :any,                 sonoma:        "167da1a869c15dd2a634c3904cace612126d0d8cb86d38b52d66aeecb4dd6101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c46693d8f26cfb4c311a8e0b1e547b9e41ebec852a2047531a5494cd532990f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "509b18b70a5c674ec72d4e2bf31002b36c27b8313ea1508410162b5fe9d1b825"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
