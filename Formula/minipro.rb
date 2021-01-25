class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.5/minipro-0.5.tar.gz"
  sha256 "80ce742675f93fd4e2a30ab31a7e4f3fcfed8d56aa7cf9b3938046268004dae7"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "e4b9881a816f2edc4361c95b1fc3fc583a23c7c4b402598f750958dfd5354367" => :big_sur
    sha256 "dbde068c2d684536d1015f7fbbf0de358c8fef018fb1a0101736698ce35dd1da" => :arm64_big_sur
    sha256 "669b628ec5ebd155f7f3d9128c29445f81805fe368ae080e39abf46e5610c592" => :catalina
    sha256 "65a9fbfcacac226dd5d0dfae7ca08dd2bb41340f9d7a02bcb224469ea280c0c7" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "srecord"

  def install
    system "make", "CC=clang"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{share}", "install"
  end

  test do
    output_minipro = shell_output("#{bin}/minipro 2>&1", 1)
    assert_match "minipro version #{version}", output_minipro
    output_miniprohex = shell_output("#{bin}/miniprohex 2>&1", 1)
    assert_match "miniprohex by Al Williams", output_miniprohex

    output_minipro_read_nonexistent = shell_output("#{bin}/minipro -p \"ST21C325@DIP7\" -b 2>&1", 1)
    if output_minipro_read_nonexistent.exclude?("Device ST21C325@DIP7 not found!") &&
       output_minipro_read_nonexistent.exclude?("Error opening device") &&
       output_minipro_read_nonexistent.exclude?("No programmer found.")
      raise "Error validating minipro device database."
    end
  end
end
