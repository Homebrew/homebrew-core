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
    rebuild 2
    sha256 arm64_tahoe:   "0f1f6aceeab9c9545b8adcf8f16300f09b0b5355195e2a3a83bfadf18da57557"
    sha256 arm64_sequoia: "be96b6beb97aa8686d476989a0eb5ed0f9bb92341c08a251029e94fdcd2f99eb"
    sha256 arm64_sonoma:  "3475e8463cbb1e36918e222efbfc66f4f8c1574f2ccd82387b6c05eb40d83367"
    sha256 sonoma:        "9af071ccc5f99e1f20b3a970977161a3c09055a7dc57cf62213d407556264067"
    sha256 arm64_linux:   "6f22ef830d29487e4f88afaf95a912b10686b7ae963a52df49259f3c485bf2a9"
    sha256 x86_64_linux:  "47b9ae94014806770ad1b838d8a340f119c5101bfa1e125c2c32daf899edcf70"
  end

  depends_on "pkgconf" => :build
  depends_on "libusb"
  depends_on "srecord"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{share}", "install"
  end

  test do
    assert_match "minipro version #{version}", shell_output("#{bin}/minipro 2>&1", 1)

    allowed_errors = ["Device ST21C325@DIP7 not found!", "Error opening device", "No programmer found."]
    output = shell_output("#{bin}/minipro -p \"ST21C325@DIP7\" -b 2>&1", 1)
    assert_match Regexp.union(allowed_errors), output, "Error validating minipro device database."
  end
end
