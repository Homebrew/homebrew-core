class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.5/minipro-0.5.tar.gz"
  sha256 "80ce742675f93fd4e2a30ab31a7e4f3fcfed8d56aa7cf9b3938046268004dae7"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "a7f44b05364a29856b0fda0067227e3400d3580ceff69ee6264ea74b8f614978" => :big_sur
    sha256 "d5f6d8dcd449a794042dedc387107c6fd0629c72c79e765067c87244f94851b8" => :arm64_big_sur
    sha256 "eca0b4a6206491f7d429f75032bf16312078ac7bd36fffc8b97dc19b9999dbc4" => :catalina
    sha256 "a636a9d69994308ecc1340ed93285171e04c5c25f3ad7c970d31d11e7c6123cd" => :mojave
    sha256 "0969900d68207aab7fc9edca1d49f8816d2bf48a754af904ffa57466463b9c28" => :high_sierra
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
