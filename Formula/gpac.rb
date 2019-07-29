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
  url "https://github.com/gpac/gpac/archive/v0.8.0.tar.gz"
  sha256 "f9c4bf82b0cbc9014bc217d6245118ceb1be319f877501f8b6da7a284f70ec65"
  head "https://github.com/gpac/gpac.git"

  bottle do
    cellar :any
    sha256 "f2c2011bf39b446799dc060821df0947997583f2ec4793488aa98964fe6d6cb5" => :mojave
    sha256 "817c6ab9614c89b887bd2887faa03e1aaa505cf25861c9ca4c53e598b56b5396" => :high_sierra
    sha256 "d1860839d41ed5922e40c1f2b1ff6215083cfaba19d9751db985541b2cf475b8" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  conflicts_with "bento4", :because => "both install `mp42ts` binaries"

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
