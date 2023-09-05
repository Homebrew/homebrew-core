class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/4.0.0.tar.gz"
  sha256 "43b5943b8135a0b2c0bb16897291e641f38e7e81aab17a18ee3d6eb5e1cd0d48"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1419159c283b3ef33b6feeb54bfaea45f35acae79a933de2f1a0e663721a1f9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcbc212b2f6eae27ca6f786bd7304e0b33a5217a7d110398c007f7ce5d8f2a0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56c185ce1da7d5aed23d6c2c47c57ed98c1da2e897804b5cab863b4e56b78b8d"
    sha256 cellar: :any_skip_relocation, ventura:        "56c8aaafaf7ecab59d1521a394b3049f3a8a0cbd00ce39b8e327a468e921113f"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9733e5a63a29d83cedb6d6bae167ab83af2899c949453a8f0f272c8adf450e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c4ce86704274046c784a00f303e948c35967221c59d99df9dd487135a769cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a0da3ebafb75dc82ebd77765b5170c199b9713fe821aae0e55120fd0b98946a"
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
