class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/4.2.0.tar.gz"
  sha256 "8ede2b3e9e1e1fb80000362750814b0fd07911506c1ea13e38e6c2fe80f447f0"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "512d0785ee1d0a7c0018456e1a278a954ec27b119b78ea0d2fa61064322d7a20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "760dc757577039dcb20ddde4c8c526664323f612e54a49f147d1922bf555a36c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "419e468299ab898cd8f5a1f0521f5ba0dd5285502ff697f33decd6d5394576de"
    sha256 cellar: :any_skip_relocation, sonoma:         "d584ba2a31de44955ca4f01b4532ae534d1c5224dc6fee86036662e1fe179b4a"
    sha256 cellar: :any_skip_relocation, ventura:        "ec474a707f443154b9ad65edb83f118e5ecfa55bdf033cbd667af621a6606fb8"
    sha256 cellar: :any_skip_relocation, monterey:       "dfd3ced2b4140549960f243925d7cc8c6f7fb55a6dc325bb38bc6206cdea60b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "595509b4765b5d763d12f7d1cbf8e4987ac77c5253195372a2660da01d8d408b"
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
