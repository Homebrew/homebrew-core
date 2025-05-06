class Code2prompt < Formula
  desc "CLI tool to convert your codebase into a single LLM prompt"
  homepage "https://code2prompt.dev/"
  url "https://github.com/mufeedvh/code2prompt/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "08e45407b71bf5e5fb89930043b085cf8965a008dc5004d4aa4ac64db0e447e0"
  license "MIT"
  head "https://github.com/mufeedvh/code2prompt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ffb0a37cd1c18cfce0671d5f12893bf3e76861adeed8aebd0877bb0e297722aa"
    sha256 cellar: :any,                 arm64_sonoma:  "bf804355c19b6f6be322938ed43f0cc80201f1b530a5fa26ef0f155326f19f5c"
    sha256 cellar: :any,                 arm64_ventura: "2c8ece110e8e9691417400d8e011ed0954a9b7f3b160a3d0988632219cf0c5e3"
    sha256 cellar: :any,                 sonoma:        "a9a016853a6abfd026b1ab3db2205faf4da346be2fec686a5504b7eac87071a2"
    sha256 cellar: :any,                 ventura:       "7429f9f5fa52f3d55ce31b80a92feacbcf2d8dcd5a5a13ec5b3da1f50ff362a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61242b4adb9b40caf4e07985b0f3e8296574322f18b60cf459812cf6e8197e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef85b418af9acc67de01f42ac222b996933588a6f8d02cd7b162346aae8084ff"
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
