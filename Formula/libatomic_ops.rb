class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-7.4.4.tar.gz"
  sha256 "bf210a600dd1becbf7936dd2914cf5f5d3356046904848dcfd27d0c8b12b6f8f"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "cbb473e519b1a3ca0652a994b27d0e1e79be1a620e0a633f81a613127fb6ed44" => :el_capitan
    sha256 "9a149cc8ba1978bd27eeac295ba0b68026d32b4f732f61937534435cbf3e5558" => :yosemite
    sha256 "74f72421aaf164af27890dc4d53d87fd1e06ca175c611d474b782afd967cd399" => :mavericks
    sha256 "b9d20bfe742eb48b6bc491459ee20f69acde47e757b03817544e79c5be80ec61" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
