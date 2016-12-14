class Libunwind < Formula
  desc "C API for determining the call-chain of a program"
  homepage "http://www.nongnu.org/libunwind/"
  url "http://download.savannah.gnu.org/releases/libunwind/libunwind-1.1.tar.gz"
  sha256 "9dfe0fcae2a866de9d3942c66995e4b460230446887dbdab302d41a8aee8d09a"
  head "git://git.sv.gnu.org/libunwind.git"
  # tag "linuxbrew"

  bottle do
    sha256 "caabeb18f79a24a02caf5c3f706c144173310410bddd470160909b3eda391a41" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}",
      "--disable-debug", "--disable-dependency-tracking", "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "pkg-config", "--libs", "libunwind"
  end
end
