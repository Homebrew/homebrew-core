class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.23.tar.lz"
  mirror "https://ftpmirror.gnu.org/ddrescue/ddrescue-1.23.tar.lz"
  sha256 "a9ae2dd44592bf386c9c156a5dacaeeb901573c9867ada3608f887d401338d8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c229db4c0e74144c629f0e95014216468d05eae87ded6d5d730745edd98c51b" => :mojave
    sha256 "cea23ba7f2730135b634d896d835c9c55572900fbc8263993697e1273b67dfb0" => :high_sierra
    sha256 "b0759371cbeedf705c56867910da5536f4aa8b6560d2ebdf8fd6c9f2ba71199e" => :sierra
    sha256 "eab68f77a7570e59f007ea4b6fe47b9882c24ad2b626db375f9f42888476cf5c" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system bin/"ddrescue", "--force", "--size=64Ki", "/dev/zero", "/dev/null"
  end
end
