class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/1.6.1.tar.gz"
  sha256 "5b3de8c0375a87094ecbccdd57b89a65b465c25e2ffd8dfdffb1ab08346e4cb1"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19edf275b9506482a8aa3734c2e36c3df87af66281a7e3e18e559841ddfe53d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f1e04e3ea79619d6d9f127cc5533c308bc3400613984cd8afc1f453542d5852"
    sha256 cellar: :any_skip_relocation, monterey:       "943504074d5cc502dadd567ab6fd0efb91c007e5c2845a21ae3bb1b1eba8c444"
    sha256 cellar: :any_skip_relocation, big_sur:        "41bdb99d847cd1dab3ba73b6404e4861fd2deaf5a6cc603b999b24630aa7cce4"
    sha256 cellar: :any_skip_relocation, catalina:       "3f5f2db9672ab66e4d4c1a16f3f16929d607fe2798b25c89ca2671575fd3c2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ec2691ce5a046afbfe53b8d3b9ca9b31fe8e9790b10a56be9fedfd95bbc5265"
  end

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "openssl@1.1"
    depends_on "pkg-config" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "packages/hurl")
    system "cargo", "install", *std_cargo_args(path: "packages/hurlfmt")

    man1.install "docs/man/hurl.1"
    man1.install "docs/man/hurlfmt.1"
  end

  test do
    # Perform a GET request to https://hurl.dev.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.hurl")
    filename.write "GET https://hurl.dev"
    system "#{bin}/hurl", "--color", filename
    system "#{bin}/hurlfmt", "--color", filename
  end
end
