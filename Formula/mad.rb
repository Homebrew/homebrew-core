class Mad < Formula
  desc "MPEG audio decoder"
  homepage "https://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/libmad/0.15.1b/libmad-0.15.1b.tar.gz"
  sha256 "bbfac3ed6bfbc2823d3775ebb931087371e142bb0e9bb1bee51a76a6e0078690"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libmad[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "e6a54111ab617580c360bfa07c8503cddf52b1df5bda2cd51da086e4e9470223"
    sha256 cellar: :any,                 arm64_big_sur:  "ee9a37f6202a784c1564ac92613821e9bfd0f75fca8ef24262e444e5ec424ca6"
    sha256 cellar: :any,                 monterey:       "912da077a9ff47e8e0b19ed160646c8a365e448b81786fbc2f64a2813c8d6b33"
    sha256 cellar: :any,                 big_sur:        "0ad06329f73d5dc15cba262feca6e1c582e10ad3b9ca0476e46c37e6d878d0ab"
    sha256 cellar: :any,                 catalina:       "5416172dc7ccd3c5a5065b3f7dc18c00e83a7e20dfc6b09e0586afc4a76c5722"
    sha256 cellar: :any,                 mojave:         "5baadb23763805521d306268861ff82fe2055da1eb7976aaa7c78f83d3c2f43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05670a88d2d0a50d03407a39987c573806c8bf9b7d67f2df4db3d121328123ae"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    touch "NEWS"
    touch "AUTHORS"
    touch "ChangeLog"
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debugging", "--enable-fpm=64bit", "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", "install"
    (lib+"pkgconfig/mad.pc").write pc_file
    pkgshare.install "minimad.c"
  end

  test do
    system ENV.cc, "-I#{include}", pkgshare/"minimad.c", "-L#{lib}", "-lmad", "-o", "minimad"
    system "./minimad <#{test_fixtures("test.mp3")} >test.wav"
    assert_equal 4608, (testpath/"test.wav").size?
  end

  def pc_file
    <<~EOS
      prefix=#{opt_prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include

      Name: mad
      Description: MPEG Audio Decoder
      Version: #{version}
      Requires:
      Conflicts:
      Libs: -L${libdir} -lmad -lm
      Cflags: -I${includedir}
    EOS
  end
end
