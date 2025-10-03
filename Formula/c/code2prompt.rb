class Code2prompt < Formula
  desc "CLI tool to convert your codebase into a single LLM prompt"
  homepage "https://code2prompt.dev/"
  url "https://github.com/mufeedvh/code2prompt/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "ea587473f2c66afa533f54d76abc45ad23623eaa3650ee7e8d0bc618ee75c0e7"
  license "MIT"
  head "https://github.com/mufeedvh/code2prompt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39e9acc3e7ddee5b590994cdf30e5d1e1424e85aeaa759b84fd3f8df710cdcf2"
    sha256 cellar: :any,                 arm64_sequoia: "e9f49fee5ddea12d9683e131a68c8241eab35381ad1d5d79ab7bb5e69dec80ff"
    sha256 cellar: :any,                 arm64_sonoma:  "c9ce03e8d805ca949b997a55a513632bcb6e02da39efac5d30fd12981253b239"
    sha256 cellar: :any,                 sonoma:        "a6ec265b32a19d46f22f677ed9d15229652acc4c929f72ab9f3e4076db84f906"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34fd986896b0f0837cd417c3cd219bb236ce5f9ef3d45688680f85eaef95b96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35b7d1ba2ae1c91fd857bdd897e3b8a9fb033fdeb7013bf131ba641146aab464"
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
