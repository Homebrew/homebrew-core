class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.7.2/minipro-0.7.2.tar.gz"
  sha256 "77961e24da3fd14844768102893b291c55b379e49938b3665a9033622def8cbb"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/DavidGriffith/minipro.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "49928d7fc034b02531e4c7cced9ebc7475f8aaa22119fe80a5e991ad393b9626"
    sha256 arm64_sonoma:  "9516b8133d1301aa662a9b6fe7be10ecdf2516399da38fef7ab1277d36cec240"
    sha256 arm64_ventura: "615be8caf35c15d4b0c8446545dd812c2993ff6dd97191bdf975a06b959902c9"
    sha256 sonoma:        "b6db0de40d57c21ab00d71bb28c979c81c17746ce881ca1c8552634eb6fea1c6"
    sha256 ventura:       "f6b63ad0e8201c67ae3812ac40543837a428a663bad1398fd4a5f8d9ef42d55e"
    sha256 x86_64_linux:  "7c0587d281ee52203b8346e78d4d42631fc008e47f60298e2559524122515413"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "srecord"

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{share}", "install"
  end

  test do
    output_minipro = shell_output("#{bin}/minipro 2>&1", 1)
    assert_match "minipro version #{version}", output_minipro

    output_minipro_read_nonexistent = shell_output("#{bin}/minipro -p \"ST21C325@DIP7\" -b 2>&1", 1)
    if output_minipro_read_nonexistent.exclude?("Device ST21C325@DIP7 not found!") &&
       output_minipro_read_nonexistent.exclude?("Error opening device") &&
       output_minipro_read_nonexistent.exclude?("No programmer found.")
      raise "Error validating minipro device database."
    end
  end
end
