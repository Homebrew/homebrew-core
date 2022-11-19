class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://github.com/folkertvanheusden/HTTPing"
  url "https://github.com/folkertvanheusden/HTTPing/archive/refs/tags/v2.9.tar.gz"
  sha256 "37da3c89b917611d2ff81e2f6c9e9de39d160ef0ca2cb6ffec0bebcb9b45ef5d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d94a9daced98c5e2e3b192a2d90e4572b4aea047c3572810f5e437f2c03d7e8f"
    sha256 cellar: :any,                 arm64_monterey: "c846542d55c712401ea113493bac025d53c760cb34e4afbdbf0589cc480cf040"
    sha256 cellar: :any,                 arm64_big_sur:  "009816a0db310663c27211705990e2e6b31fa04bec6c8e31d974e3b91f6fdafc"
    sha256 cellar: :any,                 ventura:        "d94abf69cdd015418cfb0ec25dd0f2542186933a7cfda72a293aac88f072a0a1"
    sha256 cellar: :any,                 monterey:       "3bb35f1f10a559975d926cf8659cd4fe5474a054f97e6465b700075e598c4d4c"
    sha256 cellar: :any,                 big_sur:        "01023fd55b938b08b2ba9d244a6ac5f4917e0eab92c07d77976a89df39c844b3"
    sha256 cellar: :any,                 catalina:       "e6599bb0b22aeb3cb4d637e310b8d0af1f68220f05be7fdce866b421d40c6586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db4d5364a17224f353ae268afb1ac9090814fb7cf656f88b757b5e325bb25c3a"
  end

  depends_on "gettext"
  depends_on "openssl@1.1"
  uses_from_macos "ncurses"

  def install
    # Reported upstream, see: https://github.com/folkertvanheusden/HTTPing/issues/4
    inreplace "utils.h", "useconds_t", "unsigned int"
    # Reported upstream, see: https://github.com/folkertvanheusden/HTTPing/issues/7
    inreplace %w[configure Makefile], "lncursesw", "lncurses"
    ENV.append "LDFLAGS", "-lintl" if OS.mac?
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"httping", "-c", "2", "-g", "https://brew.sh/"
  end
end
