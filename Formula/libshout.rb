class Libshout < Formula
  desc "Data and connectivity library for the icecast server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/libshout/libshout-2.4.3.tar.gz"
  sha256 "0d8af55d1141bf90710bcd41a768c9cc5adb251502a0af1dd22c8da215d40dfe"

  bottle do
    cellar :any
    sha256 "f27b22e83aa66084bf028112aa63c117a477250174f2cb3ce3f32f724327793f" => :mojave
    sha256 "72d94be39d86d20c2b4c2742070871ed5633e09dffa37bb4fbd72696a1af39bd" => :high_sierra
    sha256 "9bb870963da43d4c45b2da70fdf81ee3b50bd7123c6d46a187c618cddd488420" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "speex"
  depends_on "theora"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
