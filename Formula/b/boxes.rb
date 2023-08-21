class Boxes < Formula
  desc "Draw boxes around text"
  homepage "https://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v2.2.0.tar.gz"
  sha256 "98b8e3cf5008f46f096d5775d129c34db9f718728bffb0f5d67ae89bb494102e"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/ascii-boxes/boxes.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "bae581a59dcb2b51d6ff1cb1305a61222f742cddb3980bb2c1adab6165d4955e"
    sha256 arm64_monterey: "adf2e35fd66cb5b4979f98cb0939a80ac8437c72c0d756b64064f6e7badf514c"
    sha256 arm64_big_sur:  "4cbf476f6600a5f638afbe425af86f0870b87ba754b3efc8650415688ef9cfef"
    sha256 ventura:        "0d38ba27787c51605ba631b7761ef8e4217a9f8e90eb695b1b6fccc7a2b02f09"
    sha256 monterey:       "4deece97d1b40f1c5e159de7b306b2fb8f503f60dacc95c87640f614b2420559"
    sha256 big_sur:        "5b72fbbc60ab92556f9da91e8a2543c432cb70ad18bfe337005ef731f310a8ec"
    sha256 x86_64_linux:   "374ea58aadd6f262e27c0e9613b99af5de961264abe66df48de0e6c087193c97"
  end

  depends_on "bison" => :build
  depends_on "libunistring"
  depends_on "pcre2"

  uses_from_macos "flex" => :build

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
