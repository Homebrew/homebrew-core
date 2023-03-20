class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/2.0.1.tar.gz"
  sha256 "6fa3524be56027748aa13afc72487fc07f5b1ef3bf4ccdeb9c641436b3dcd4d3"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec06767e3c13ce75cbc38d4a58a9a666bcdde27cebdeca334f9e8938b3132bcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f6d0d17661b13880620f78eedd1a2645a1ba2f730221eb26caa7ae72a02864c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1fbcbd68edfe5292957ec1b7c3cd4897f53632acc62c18367bc74be39104f49"
    sha256 cellar: :any_skip_relocation, ventura:        "ace14dc57f016b28abc0e35332b7d369216decb7f113babc95381afeb93db992"
    sha256 cellar: :any_skip_relocation, monterey:       "fb1fb9e4956f4c2da9d35a85843443895272a73f46028e9650c8b8ea97c1aec9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb418a569526fb28b0503543c1b5b6c5cc7b51d94ba15e03393589586b40446c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8da8fefe3b5d1f603cf93b5a9ee8716e889d881b54d9ccf8b1c4fee1c2f0816e"
  end

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "packages/hurl")
    system "cargo", "install", *std_cargo_args(path: "packages/hurlfmt")

    man1.install "docs/manual/hurl.1"
    man1.install "docs/manual/hurlfmt.1"
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
