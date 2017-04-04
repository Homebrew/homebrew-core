class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/debianutils/debianutils_4.8.1.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/debianutils/debianutils_4.8.1.tar.xz"
  sha256 "2c395c0bdcfe89de30828b1d25cc5549ded5225a6d3625fbcb2cc0881ef5f026"

  bottle do
    cellar :any_skip_relocation
    sha256 "a81763f60f0bd1723124df4442bccb31df9b8ab197aa3f94e89ad796c6a3198b" => :sierra
    sha256 "4a601c8b9558e41ee5352190fa58f4104c14ae05861a4628a90b0779a262018a" => :el_capitan
    sha256 "fc466c2f03b2f23b9d0b3da35ab6b3b82714c3c512bc04471e71a39e9d04ed49" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"

    # Some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install "run-parts", "ischroot", "tempfile"
    man1.install "ischroot.1", "tempfile.1"
    man8.install "run-parts.8"
  end

  test do
    assert File.exist?(shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip)
  end
end
