class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/4.1.0.tar.gz"
  sha256 "3356f64158e6dc5f2e29c37eee80a43332b1734baa7380356affeb5160ffca09"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26ffa5e43f3010b45c01ddc39bb3a93dbb252a1725373c8a4f11abba4c0b7ea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d082dae01d806d74726a8da68aef0a616c382eb2759e5b3512d62c7c9a4ef29b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be207c134e75c207390a606632e9e8ca43c5effe6c51b33f207720979b485d45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f4d689d7d49782d8d2500fdd914db6a6b42d46ef4eac745393115c3f63a9202"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd24dec5e5b6b6c4422f144bc769c049f33d6b0d29f8e5e1465ed1daa04b027a"
    sha256 cellar: :any_skip_relocation, ventura:        "087460804017a0c82bcc77c9d5d86199a497bbaf39111a79c8060a6e244091a5"
    sha256 cellar: :any_skip_relocation, monterey:       "c2f473d0077aa7a3b05ffc8fdacac23aefffde6108cc0d43e0898ed92a1c4af4"
    sha256 cellar: :any_skip_relocation, big_sur:        "270debc26fba57ea84f71063168cab45dbce99d8ea76fddb5aa4ed94ba603ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2075cf2a9f72b123b750e4753d18da73b871fd8ec0ebcce553cf0535ce20e1f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    # FIXME: This formula uses the `openssl-sys` crate on Linux but does not link with our OpenSSL.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
