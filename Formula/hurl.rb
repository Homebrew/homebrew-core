class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/3.0.1.tar.gz"
  sha256 "551a730ed23150bc0a120781abe8c36b2989abc03c97c3e79191eea87cca5632"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5939a93f8e90462fa77acb1149bab7e75a66222288a87b81dbab3c45ea207300"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc5f5e61e1e01d3e32d22bdf5c2acb7c50317a9283434302cd85d5af400fa8c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5aa0007cb7cf0a770da856271cf1cb85afed4056812106dba5c330ace3785c4d"
    sha256 cellar: :any_skip_relocation, ventura:        "4534f14622f38add2346271b31d101cfaa6334b63006556fe39075980b8409b8"
    sha256 cellar: :any_skip_relocation, monterey:       "b50a98e382edb39e9a06dfed0dbabdbc509f53545f9b982262b4dc85534e1d1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a45489c8c9105f8ed5df00809a5a44e3905082fe56cffc847ac5234adf35e789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eb1ae2a9bb8d375810b665ae11aa4bf336bfa2ab25804ece21d82d4a00e109e"
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
