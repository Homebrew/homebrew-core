class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/3.1p1/owfs-3.1p1.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/o/owfs/owfs_3.1p1.orig.tar.gz"
  version "3.1p1"
  sha256 "e69421ae534565c1f8530a2447f583401f4d0d4b1cf3cb8cf399a57133ed7f81"

  bottle do
    cellar :any
    sha256 "be0fba236f76563fb7927c40d47e0037c046de115057ab514c4d1cc214ea6a07" => :el_capitan
    sha256 "97c0ad182ab7c5f000ed8734272be3a0aac38cf6df9cb7bb2e0f67825cf0a717" => :yosemite
    sha256 "5682fed7463f0c20636a6fb961ff4edde845a497b55618eaff2d986613e09e20" => :mavericks
    sha256 "f71d3106d44a4afd36a8d19057da893528e85c528a5727cc1ed278db0e44da2e" => :mountain_lion
  end

  depends_on "libusb-compat"

  def install
    # Fix include of getline and strsep to avoid crash
    inreplace "configure", "-D_POSIX_C_SOURCE=200112L", ""

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-swig",
                          "--disable-owfs",
                          "--disable-owtcl",
                          "--disable-zero",
                          "--disable-owpython",
                          "--disable-owperl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/owserver", "--version"
  end
end
