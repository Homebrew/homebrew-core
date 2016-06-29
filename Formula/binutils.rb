class Binutils < Formula
  desc "FSF Binutils for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/binutils/binutils-2.26.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.26.1.tar.gz"
  sha256 "dd9c3e37c266e4fefba68e444e2a00538b3c902dd31bf4912d90dca6d830a2a1"

  bottle do
    sha256 "6290d3d2b56f5b9450043d1f71d0597e7405e6d27c1c6eddd54f1f6bb5ff96f0" => :el_capitan
    sha256 "12f87ef4be8a0ea5d92cf9ef2f6bb3db8b1836c61d7ab0a95ddcea3a6b8dc37f" => :yosemite
    sha256 "a82e26a42ba2775534c7b3651feacfd1d3be7b4e83cfbe3635c7f728ac2cbb4d" => :mavericks
  end

  # No --default-names option as it interferes with Homebrew builds.

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "main", shell_output("#{bin}/gnm #{bin}/gnm")
  end
end
