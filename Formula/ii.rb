class Ii < Formula
  desc "Minimalist IRC client"
  homepage "https://tools.suckless.org/ii/"
  url "https://dl.suckless.org/tools/ii-1.8.tar.gz"
  sha256 "b9d9e1eae25e63071960e921af8b217ab1abe64210bd290994aca178a8dc68d2"
  head "https://git.suckless.org/ii", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "cb33673d9ff4f1ae5df30e60ece783e6c7e2024f2722fe96dd60ab9504b124e5" => :high_sierra
    sha256 "1315c3181d0c2320d05927e84f84a8b1a0de21d9f53e448993e95fb00a1489a0" => :sierra
    sha256 "7f1cb092b6940dc4d9b1e1e47b78165c6f37c0dc322dc0bfd5053afcb42e3fb6" => :el_capitan
  end

  # Updates Makefile, and provides an option to use the system strlcpy
  patch do
    url "https://git.suckless.org/ii/patch/?id=e32415744c0e7f2d75d4669addefc1b50f977cd6"
    sha256 "b01aa1e7c6d8f112b3c73491c7eebc2d61c97daeb32ae33e070aa6356c8c2128"
  end

  patch do
    url "https://git.suckless.org/ii/patch/?id=51cb204eb2a7ee840a86cc66b762ddfff56f01b2"
    sha256 "15a675f256e3ff75a13a3427f9039d0597bb0580576f5fd80d25bb9f04d720cc"
  end

  def install
    inreplace "config.mk" do |s|
      s.gsub! "/usr/local", prefix
      s.gsub! "strlcpy.o", ""
      s.gsub! "-DNEED_STRLCPY", ""
    end
    system "make", "install"
  end
end
