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
    sha256 "e035d74171aa4179277bf62734f21fb06688f0a7b10bb6ac57bcdc7124b0453f" => :mojave
    sha256 "1e369830820f2e7553bcc498af2a839005c3f8a6327781cd4f6f46252ae42ca6" => :high_sierra
    sha256 "c9d6d00656293f4d40185460807b7c489d8d2e7db4bc4e95af9ede968260f4e1" => :sierra
    sha256 "46428c9cb8fdf15ebe9014667f9158444b263e60b5836688625b300f389c64e4" => :el_capitan
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
