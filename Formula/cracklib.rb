class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/v2.9.8/cracklib-2.9.8.tar.bz2"
  sha256 "1f9d34385ea3aa7cd7c07fa388dc25810aea9d3c33e260c713a3a5873d70e386"
  license "LGPL-2.1"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a0d1701b52f2e2909fa56d2e8b3ac130574f8e5e3b3a3384d40a285d9a5a3a2a"
    sha256 cellar: :any,                 arm64_monterey: "37e11c7758cab905a8fd3d6ac8ea2e42e76a0781eab77b1876c54158acd1a220"
    sha256 cellar: :any,                 arm64_big_sur:  "9c00da21b9605563490fa418eb694b90b41dcdd112a6cfdf2994911b5488ffd6"
    sha256 cellar: :any,                 ventura:        "9a4724bc32453adfbd8a2ad0389244762f54c8096d87ec5c1696ac84475bada2"
    sha256 cellar: :any,                 monterey:       "406463c04be8c31174159aba08a888858467f973dc6e7ac9a13616446116fded"
    sha256 cellar: :any,                 big_sur:        "58e11929dc53ac1a420b4c532f17ff57c16f7af59d848d7a24b2637351e375f5"
    sha256 cellar: :any,                 catalina:       "03d86f4ec7debecabbe347eac8d5969dd483862134957ff55d84988bf1abe683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c419da2984ccf5a47fdc40448d58e0a824fd4675b3cce6d152282962abf6d621"
  end

  depends_on "gettext"

  resource "cracklib-words" do
    url "https://github.com/cracklib/cracklib/releases/download/v2.9.8/cracklib-words-2.9.8.bz2"
    sha256 "ec25ac4a474588c58d901715512d8902b276542b27b8dd197e9c2ad373739ec4"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}/cracklib/cracklib-words"
    system "make", "install"

    share.install resource("cracklib-words")
  end

  def post_install
    (var/"cracklib").mkpath
    cp share/"cracklib-words-#{version}", var/"cracklib/cracklib-words"
    system "#{bin}/cracklib-packer < #{var}/cracklib/cracklib-words"
  end

  test do
    assert_match "password: it is based on a dictionary word", pipe_output("#{bin}/cracklib-check", "password", 0)
  end
end
