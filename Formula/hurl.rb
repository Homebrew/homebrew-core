class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/1.6.1.tar.gz"
  sha256 "5b3de8c0375a87094ecbccdd57b89a65b465c25e2ffd8dfdffb1ab08346e4cb1"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "672ef9da61cf8940003dca14c27c158dfe9b7c29029321c36e93228a3f527453"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a853ce47b5e8882e058d5d55a4495f9be5dcb6ee1625a436eeb81765b2703089"
    sha256 cellar: :any_skip_relocation, monterey:       "b8a9871aaf4dcb98a276d96689b9426a727dcba62ae10058510d4e055f44204f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc7f03292ca0fd28de91eb0c43f6b91cfd4225c1b363a241e82b9c76ea3ce545"
    sha256 cellar: :any_skip_relocation, catalina:       "26f9f25d03777db1975867c808df86763bb40e0e213e0dc935ef70d6cb396a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adfbab5349cb2b40d8f34e17e28e317086397a61e9ac0a497d0a63178f73d6f3"
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
