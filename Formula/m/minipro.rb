class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  # GitLab tarball is keep changing checksum, so we use git tag
  url "https://gitlab.com/DavidGriffith/minipro.git",
      tag:      "0.7.4",
      revision: "3808aecb6a1dac9906a9691b93820ee1bd2b7a18"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/DavidGriffith/minipro.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "13bf4c41ff4d6891b353ade71ac5e25c879392ea605a29bc9354cff9acc28702"
    sha256 arm64_sequoia: "4becb73379ef89e434edcf54f3e268649586ccbdee7dd9f85436eaa757aad47c"
    sha256 arm64_sonoma:  "06cc2da2326ef31264e060e8168e8b3920355a36cd53bb6769b234d1cb1110d7"
    sha256 sonoma:        "82ce14e63986e7851eafbfc4c24594275432b1546bee2ecc1f4b08a07d12b717"
    sha256 arm64_linux:   "9f93a79729a8b337f24fc62ea86bbfb0788f32efd553a69025da0598914a5654"
    sha256 x86_64_linux:  "46837cebd883c96a26d4d3b89aaa4790e737e3b75cd9c82d9bbdea0a11cb0259"
  end

  depends_on "pkgconf" => :build
  depends_on "libusb"
  depends_on "srecord"

  uses_from_macos "zlib"

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
