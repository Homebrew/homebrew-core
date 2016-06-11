class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "http://ftpmirror.gnu.org/freeipmi/freeipmi-1.5.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.5.2.tar.gz"
  sha256 "734fa260e71d11e0a607f8acc731b9492f7f7b2f5476bf2ec29ff34ecde4ee75"

  bottle do
    sha256 "b9d518e944117047473837837cde246d0ad208c30816b0afc105a48db479ac43" => :el_capitan
    sha256 "ffbb10eacefd0f6316d628263c265836086d2abb12a48036325348357612c364" => :yosemite
    sha256 "64225327a2acefb097ba9e580bc8e307095c72b6b2d424053e87dabeb242fd74" => :mavericks
  end

  depends_on "argp-standalone"
  depends_on "libgcrypt"

  def install
    system "./configure", "--prefix=#{prefix}"
    # This is a big hammer to disable building the man pages
    # It breaks under homebrew's build system and I'm not sure why
    inreplace "man/Makefile", "install: install-am", "install:"
    system "make", "install"
  end

  test do
    system "#{sbin}/ipmi-fru", "--version"
  end
end
