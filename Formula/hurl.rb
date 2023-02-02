class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/2.0.1.tar.gz"
  sha256 "6fa3524be56027748aa13afc72487fc07f5b1ef3bf4ccdeb9c641436b3dcd4d3"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82409a212f2c0e38261ad5a8fd9c5084360063578240427124e183b827e0c290"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c13ba0cf2195e96e77d38e69934c4a506a135951fec2a2bdbc66d922098747fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b32e95a475cd1cbd1eed88779e594f2b80d71689adfd23c08d5012df317aac7"
    sha256 cellar: :any_skip_relocation, ventura:        "205c2c9505066b43325c940bd35bb45896fb8277552b01e3c5966c31f0ccd763"
    sha256 cellar: :any_skip_relocation, monterey:       "914f7833b3297367341af824d57c57af0eefb89f986000a92ac4c00583ebfe4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b43172850809ac87ea77d0c92affa933a0aed059aba9f91edff2659b630ab010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "115b3729b3aaf760fa79257cc171ad9f5479cd13f272e1b4f6e5bd870fc26764"
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
