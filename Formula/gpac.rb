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
  url "https://github.com/gpac/gpac/archive/v2.2.0.tar.gz"
  sha256 "c20c204b57da76e4726109993c1abcdb3231a9b2ee2c8e21126d000cda7fc00d"
  license "LGPL-2.1-or-later"
  head "https://github.com/gpac/gpac.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d0558e09d42e44644581c62b64a8109d6968f07ea8e00a9f6e78453242c31f77"
    sha256 cellar: :any,                 arm64_monterey: "e7bdaa0c5bfd09b4e29908df5ecace8c9c3f1ab7d04802357077c1ed1c31e4fa"
    sha256 cellar: :any,                 arm64_big_sur:  "b8b0aca468db112cceea2ebbd9dca6ad2441095e8bcd85c99788a9bb6fdd5796"
    sha256 cellar: :any,                 ventura:        "8e8ee917157aa2535ae182767e45eee02a77545d30535d3b2fa9b75ea437157e"
    sha256 cellar: :any,                 monterey:       "79d93bb80dcc146cc18f2e5de8904060de7982a01061d0211c51639dfa18ecaf"
    sha256 cellar: :any,                 big_sur:        "6e2b5266dda770fafe8159528424fb2e27cbd8ed3cac80accf6f2ab85506e8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "279485e406963ddacebdf8a1aec5331bf262915164c567b4a0725a015d802104"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

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
