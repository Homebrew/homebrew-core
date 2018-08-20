class B43Fwcutter < Formula
  desc "Extract firmware from Braodcom 43xx driver files"
  homepage "https://wireless.kernel.org/en/users/Drivers/b43"
  url "https://bues.ch/b43/fwcutter/b43-fwcutter-019.tar.bz2"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+files/b43-fwcutter_019.orig.tar.bz2"
  sha256 "d6ea85310df6ae08e7f7e46d8b975e17fc867145ee249307413cfbe15d7121ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "51b5702dd05e2afc1f8f0e4c10ccf38023610706fae51112a220284bd9976daa" => :mojave
    sha256 "abbde23073e94982c1f47ea1884abf4b855f8ab0ed8d0e2434de4ca32bfc8dca" => :high_sierra
    sha256 "f5238356964126642e9dd5c88de5564f221db86d488ca826055629d504a71426" => :sierra
    sha256 "d24bbb9e1669ef33319b23a37a8ebd4dddaf8d1ce2c9e24abff13d678e3633d4" => :el_capitan
    sha256 "fed62452f6d8b74976575b0b2fc3f5fac351981ac85768160bb188a6c55ff170" => :yosemite
    sha256 "b2d662d6f951714738626f19698922875b4f97d149fbc8a79aeac0034f75d594" => :mavericks
    sha256 "e423ba3a40a826611d5af02c7267b9d260219c1012add5291b3df09002abfa5f" => :mountain_lion
  end

  def install
    inreplace "Makefile" do |m|
      # Don't try to chown root:root on generated files
      m.gsub! /install -o 0 -g 0/, "install"
      m.gsub! /install -d -o 0 -g 0/, "install -d"
      # Fix manpage installation directory
      m.gsub! "$(PREFIX)/man", man
    end
    # b43-fwcutter has no ./configure
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/b43-fwcutter", "--version"
  end
end
