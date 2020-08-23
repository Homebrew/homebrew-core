# Installs a relatively minimalist version of the GPAC tools. The
# most commonly used tool in this package is the MP4Box metadata
# interleaver, which has relatively few dependencies.
#
# The challenge with building everything is that Gpac depends on
# a much older version of FFMpeg and WxWidgets than the version
# that Brew installs

class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.wp.mines-telecom.fr/"
  url "https://github.com/gpac/gpac/archive/v1.0.0.tar.gz"
  sha256 "ebcca41993e51706c891dba4e9fe03b59bc671c41910bc6c303ba3feeb7f1b20"
  license "LGPL-2.1"
  head "https://github.com/gpac/gpac.git"

  bottle do
    cellar :any
    sha256 "615c346a9a86fd6fcdc1591bf6c5a634ae408e0ba39e11ec1b9e011488e278e3" => :catalina
    sha256 "167c5e24935a3f4b118e0d931f1d3ed2a4101a39b5de85910ec7384ee13f95b1" => :mojave
    sha256 "420874d6129c931e0dd7051bb2a91fd492f40456ade36259de611546f409f539" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  conflicts_with "bento4", because: "both install `mp42ts` binaries"

  def install
    args = %W[
      --disable-wx
      --disable-pulseaudio
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-x11
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/MP4Box", "-add", test_fixtures("test.mp3"), "#{testpath}/out.mp4"
    assert_predicate testpath/"out.mp4", :exist?
  end
end
