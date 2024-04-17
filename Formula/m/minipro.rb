class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.7/minipro-0.7.tar.gz"
  sha256 "febd2aa1a7e8d7d5b2c4de62503f37e562633a1d2b2bf78b788e49ac06847ab4"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/DavidGriffith/minipro.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "7683f032c841d97795fc78c53bf54eb1001158ff4629ffb8b2bc71a4f8d53206"
    sha256 arm64_ventura:  "9c24b204d138e6ae6f700f605377fb3b2e79c41598ec4cda73bfb3bc199e81a5"
    sha256 arm64_monterey: "042ef3b0b0a7a518ae05e9550272397efb42ea7988646812591c14bf86dc486f"
    sha256 sonoma:         "c693bc5fc151bb8ae485d32fde83a33c37bfc983ae6a0cb5e0b475d1cfae840e"
    sha256 ventura:        "e554d7dff64cd94861d766390371770ca570f223543cc6080084b0c4fd4a4d74"
    sha256 monterey:       "a582c896da5a80544e9b6af4729ffc300cbd4d85a41f10b6c1f15327686686a6"
    sha256 x86_64_linux:   "ea50165c90c5e75b67e01f5911564c96e52742fd14fa822743955472f04a5123"
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
