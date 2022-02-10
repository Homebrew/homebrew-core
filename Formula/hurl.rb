class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/1.6.0.tar.gz"
  sha256 "6b47a273fccde64d1e82d6f87e9a7524f9a4f4a7e02dc4cf3d902386dc3da063"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13bb91c14e37c6204cec38cffc6a651bdcaaad9ffaba793ec090c3ef03e81369"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4910354f6e9409404925ea409868103ca613a815086c4b34b6479dfc1e88606e"
    sha256 cellar: :any_skip_relocation, monterey:       "fe6aad9e358ec2e5ff1719373813823e07c6536b8b4162fa8906bdc3480a11a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dafc5f5809350975b0961a429c91a4929ae12289a72f5e46c7c3af221be7bee"
    sha256 cellar: :any_skip_relocation, catalina:       "088e037542a1900027f1315878aa707090e261664cf7a43f847cea5c2dff3655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6d9da7f2583875f9eee5f1518dc63156257557bf6e727d0fa2b260279a2a230"
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
