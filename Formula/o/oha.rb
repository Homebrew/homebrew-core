class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "58a46724376f4da9af9d3f74df5fae9119f864059db305fb0ecbe9b4b8b8d279"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57c97894d51d928ffe555c4f95b82e4654fc6ff606f19ca594c5705a6206460d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c153f1aed18d35a489a8b521c474cd43dc947dec0fe43a7b9b2371eb88c4dd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3503b6f854a857cfef3a2f1d1abd7c68809b3723e06f878c7d11a28ff7abe7bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab03e40aa8ed2925990a527deb041166e5bc85a75bad14633c5568c17d068a6b"
    sha256 cellar: :any,                 arm64_linux:   "b51416d4ae8c3b5f7f73c1fa4b1c470eafb2a53aaae80a1fb6585b9f1f132949"
    sha256 cellar: :any,                 x86_64_linux:  "fd5a503f6a9518e717d2ca434e9b58e6ef695810f827efe762ef32069b697d10"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
