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
  revision 1
  head "https://github.com/gpac/gpac.git"

  bottle do
    cellar :any
    sha256 "4fc891e2da6330b285fa451d8ef381a584ce6db88775b236dfea9be15ca5ec94" => :catalina
    sha256 "e524e50f08bcb03f3c8af5313f517bd51382a0cf830aa632499834e1f396514e" => :mojave
    sha256 "3cc7442693e7173b95ae2b7cd5ed8eb4e89a7e5859284d1f12f21a181e8d2bdf" => :high_sierra
    sha256 "0f2a6e4e1a24d9754b71062cbe86c871db8a98915933a819bfee8e0e68baf4c7" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

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
