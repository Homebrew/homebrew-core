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

  # Update Makefile, upstream commit:
  # https://git.suckless.org/ii/commit/e32415744c0e7f2d75d4669addefc1b50f977cd6.html
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4a447b87/ii/e32415.diff"
    sha256 "4fe81cad8507c2cc06141171039f3c1337c2ff68f4923ff7aad9e13b79c5ca82"
  end

  # Provide an option to use the system strlcpy, upstream commit:
  # https://git.suckless.org/ii/commit/51cb204eb2a7ee840a86cc66b762ddfff56f01b2.html
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4a447b87/ii/51cb20.diff"
    sha256 "1ca71e4fe1197dadef95b9b63b594b71c5161ab0e28fe255a456f412bb8ca428"
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
