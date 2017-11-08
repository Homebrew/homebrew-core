class GnuTime < Formula
  desc "GNU implementation of time utility"
  homepage "https://www.gnu.org/software/time/"
  url "https://ftp.gnu.org/gnu/time/time-1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/time/time-1.8.tar.gz"
  sha256 "8a2f540155961a35ba9b84aec5e77e3ae36c74cecb4484db455960601b7a2e1b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3acb09ca081fcdef3c31a41b50a8d7e3d38bc68c7cb1f87128a85c394741c661" => :high_sierra
    sha256 "c3ccf53f79c148c915bf83ce2b128195fff1f614523a4db5d247df2907f37c6b" => :sierra
    sha256 "3c998fed1b824483f0fd140a0b12164ebc6bd100371dca11291d3406a26ecc47" => :el_capitan
    sha256 "d0b40a36430314f548ab3e5d362c3695b9ab38e83933a7a459deaccfa705232f" => :yosemite
    sha256 "f69ffe3bd6748843ff7013c016bf69a58efde8fb936251b0f6e9e4a2352e1450" => :mavericks
    sha256 "0b28fad39645760e643d90a93c994df01151d4ff43dc8b3c63efa8d59d17783f" => :mountain_lion
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    args = [
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--info=#{info}",
    ]

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"gtime", "ruby", "--version"
  end
end
