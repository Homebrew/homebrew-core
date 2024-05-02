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
  url "https://github.com/gpac/gpac/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "99c8c994d5364b963d18eff24af2576b38d38b3460df27d451248982ea16157a"
  license "LGPL-2.1-or-later"
  head "https://github.com/gpac/gpac.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0db848b31b7bda589b829bef38fd0d99575d1303691a04a915d66548b3dac128"
    sha256 cellar: :any,                 arm64_ventura:  "e02c1581892fd72215874516724a24eb30fb7862a1e5d45ebd7cce0b840a3908"
    sha256 cellar: :any,                 arm64_monterey: "b15f699737dc4e58fda9c8753ea2aa2f323baa0423b5424230852bdb0e35b258"
    sha256 cellar: :any,                 sonoma:         "d689fcb607e52f1111fb9ddfb6bf107a40592e16c7f7f536bcbece0b76e69145"
    sha256 cellar: :any,                 ventura:        "be9dbecc82418f0ff125b5838d56ff7e37c7818f64f090df2fc0e35fdec969b4"
    sha256 cellar: :any,                 monterey:       "618101f402082ebc311574e2de377212b20386b346f1f12ab008ded4b647e5fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa932d0f671a1643b20f381bba3181328431e5ef9555444a8d25a983ace36e1"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
