class Boxes < Formula
  desc "Draw boxes around text"
  homepage "https://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v2.1.1.tar.gz"
  sha256 "95ae6b46e057a79c6414b8c0b5b561c3e9d886ab8123a4085d256edccce625f9"
  license "GPL-2.0-only"
  head "https://github.com/ascii-boxes/boxes.git"

  bottle do
    sha256 arm64_big_sur: "55cf78c7eacc25c92a2a3539ca41b5d2ecac2b4be70ad97e124a6f76f5d4b01b"
    sha256 big_sur:       "363c7bf4f446e84c86263dc0784bfa38a8d8064e076aafa198c4b8f1ee53ac42"
    sha256 catalina:      "1f367bd90dec50e191ba8884749d0e9c926bff63913e9e70ed4b18a887a66d69"
    sha256 mojave:        "7d2bf5e65b67fbacc15bbf366decb57486393b5f53732627f09c286557e7cb74"
  end

  depends_on "bison" => :build
  depends_on "libunistring"
  depends_on "pcre2"

  def install
    # distro uses /usr/share/boxes change to prefix
    system "make", "GLOBALCONF=#{share}/boxes-config",
                   "CC=#{ENV.cc}",
                   "YACC=#{Formula["bison"].opt_bin/"bison"}"

    bin.install "out/boxes"
    man1.install "doc/boxes.1"
    share.install "boxes-config"
  end

  test do
    assert_match "test brew", pipe_output("#{bin}/boxes", "test brew")
  end
end
