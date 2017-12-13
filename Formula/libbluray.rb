class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/1.0.2/libbluray-1.0.2.tar.bz2"
  sha256 "6d9e7c4e416f664c330d9fa5a05ad79a3fb39b95adfc3fd6910cbed503b7aeff"

  bottle do
    cellar :any
    sha256 "86fb0219bcbebea899d93d618ffcbe8ae9434ba80346aec6b8612bf004d54dd3" => :high_sierra
    sha256 "027cc70d3f1d213fb2fc94c7ee11fa68e14da49c5028276a0ada242cc16da37a" => :sierra
    sha256 "a34fd7a55a8a5322a2e389889c9ec9c9e39638c59c9bb1ecfc22d2e7fa9c1298" => :el_capitan
    sha256 "967f6e43aa8e1be447a837d3eee4dd7d4542918ca375b0d1d14b6fa2dafa7c94" => :yosemite
  end

  head do
    url "https://git.videolan.org/git/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "ant" => :build
  depends_on :java => ["1.8", :build]
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype" => :recommended

  def install
    # Need to set JAVA_HOME manually since ant overrides 1.8 with 1.8+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    # https://mailman.videolan.org/pipermail/libbluray-devel/2014-April/001401.html
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"

    args = %W[--prefix=#{prefix} --disable-dependency-tracking]
    args << "--without-freetype" if build.without? "freetype"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
