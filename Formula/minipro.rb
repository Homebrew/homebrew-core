class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.5/minipro-0.5.tar.gz"
  sha256 "80ce742675f93fd4e2a30ab31a7e4f3fcfed8d56aa7cf9b3938046268004dae7"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/DavidGriffith/minipro.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "569f71476e42356da2d010cb2d4bdd3316da94b56ae5888b33e7c6b72dae105c"
    sha256 arm64_big_sur:  "3ba41fe3390795a6afd327ee42c709ca59cb6f7b4cfa2bf9bc150ddc9608b72f"
    sha256 monterey:       "b61dcb6a0b6b5c8308ddd925febade67c2533561e80daf62eb0313aaec7daace"
    sha256 big_sur:        "0590a42c14ad858823a7839a745a812b921d0e458b64568a81ca17c6f0a5bb45"
    sha256 catalina:       "c949912791a3b9c40f049a8c10f289062bbd9ede15da2f37a597c6c40c4d5f43"
    sha256 mojave:         "d54e9413a92b7bd5118b1938215d61152ea06055f0860ddcb167d74924a828f9"
    sha256 x86_64_linux:   "14ce0851d54333937203d4c75be5ec68b2f3635604b13eafe60d3d0889c33e10"
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
