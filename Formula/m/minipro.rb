class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.7.4/minipro-0.7.4.tar.gz"
  sha256 "dce22dade7fe4a5ad8435b12789144b00c6084e66573b6741402be9f08a53331"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/DavidGriffith/minipro.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "93bad4be0c8bb39e8707ebef6f8fc43c176fa07c573dc5a971134fdfcc697675"
    sha256 arm64_sonoma:  "553ab778520a770ff7df88c2c0d323f043eb9241dcddbd05fdb06375aa58bf00"
    sha256 arm64_ventura: "f27c290ca12621d5962e05d0397e311593bc871aaf8b48f5dabcbf8c57192103"
    sha256 sonoma:        "93eb653bcc554d74f65f4371450426697d60e633c4a94d8b3a253154b708b088"
    sha256 ventura:       "228ae433c60a5e5526e28c3c8b3bb0a5f2cd2a52bf90dec81dcbd020e7e91c27"
    sha256 arm64_linux:   "4cf366ab146403086b8084de6e4efdba7fba0e241242753b07d0b54cb0e9b218"
    sha256 x86_64_linux:  "c87438811f0d2e3a65ddf525a813aa72d1744bcbbfa983bb6b19361997bbceb7"
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
