class B43Fwcutter < Formula
  desc "Extract firmware from Braodcom 43xx driver files"
  homepage "https://wireless.kernel.org/en/users/Drivers/b43"
  url "https://bues.ch/b43/fwcutter/b43-fwcutter-019.tar.bz2"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+files/b43-fwcutter_019.orig.tar.bz2"
  sha256 "d6ea85310df6ae08e7f7e46d8b975e17fc867145ee249307413cfbe15d7121ce"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ba4d98184260e69c16c721c905e281f8638a34f8785ce43216093afb55305f22" => :catalina
    sha256 "0f3c2998b168c9f614f5b28e1e219acada8cdd86018706fe30c46a9b0850d73e" => :mojave
    sha256 "59c187f34c0f3e3eb99e7da175fcec4bc69cd4baea62e053898c985bef63ecf5" => :high_sierra
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
