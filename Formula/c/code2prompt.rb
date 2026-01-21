class Code2prompt < Formula
  desc "CLI tool to convert your codebase into a single LLM prompt"
  homepage "https://code2prompt.dev/"
  url "https://github.com/mufeedvh/code2prompt/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "de0fe811914bee2d03a0025e734d702d1cb50472dd75c42017cc65ac9435e481"
  license "MIT"
  head "https://github.com/mufeedvh/code2prompt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02e5313ee1e04391137b435bc3f012f58942f4572f36101be6682901245dd746"
    sha256 cellar: :any,                 arm64_sequoia: "ca1cd1d2ad45322cb1d566c1c3acdb73bbd0e470abe0740adf743c56e8c8a6eb"
    sha256 cellar: :any,                 arm64_sonoma:  "05c84df90bca289b012b49bdf24f37cdf86ab213d7109ce1407f200ca5bf323f"
    sha256 cellar: :any,                 sonoma:        "62e151d3d7bf970a88402dbbef884f0c92b611ef16da266bc7ce5bf2360ebb1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26a1054374ff05ab96d2294d5079a3b995f56c3f6fd4e9c8b5e669fc58d2406e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45ca59f26707d460a2287379ea37bd80f6c2fb81bcda5f8e947189dcfc60f471"
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
