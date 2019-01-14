class Mad < Formula
  desc "MPEG audio decoder"
  homepage "https://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/libmad/0.15.1b/libmad-0.15.1b.tar.gz"
  sha256 "bbfac3ed6bfbc2823d3775ebb931087371e142bb0e9bb1bee51a76a6e0078690"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8e94986575bc44817f6db6f5c9c777c457c3cadc3124ba57481a0fe9f2da490c" => :mojave
    sha256 "a053f1e30d1d04f8c1f472d9b0b243d9572c3e7ff2c3e46a665564021bf37432" => :high_sierra
    sha256 "1b48168bf5df9fc66703afc68ad3574b9ceb723fbcbf0f1e84c3c1c18fe6ff92" => :sierra
    sha256 "a8a162813aad00169410a8f14a39927028969c914929fafb0685f0eb80075546" => :el_capitan
    sha256 "863c71f31ecda8f97effc4dd148564e03219f8ddd162c89e054a7e57623c18c6" => :yosemite
    sha256 "7bd46d4da0f695b3a5bcc899b7139f14d11741f2e47d34f21a984f9bab953c81" => :mavericks
    sha256 "11391349b4ee378f31ae681ff5c96f7c8d1b5f2a6ad5ba6b28d12bc102cc9d6b" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debugging", "--enable-fpm=64bit", "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", "install"
    (lib+"pkgconfig/mad.pc").write pc_file
  end

  def pc_file; <<~EOS
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
