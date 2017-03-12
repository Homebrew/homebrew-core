class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/debianutils/debianutils_4.8.1.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/debianutils/debianutils_4.8.1.tar.xz"
  sha256 "2c395c0bdcfe89de30828b1d25cc5549ded5225a6d3625fbcb2cc0881ef5f026"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ecea6c34bcffe9569e1c89da25f519bda54229df0e85d746eb6a69c3c0f11f0" => :sierra
    sha256 "cc2737f10b74c599e5c82fc38e220a058a0c66a2a63ddd6727771426f4299d91" => :el_capitan
    sha256 "7a1153519d3f511f1faceea3aea7bb46e5a0cdc73b27199658439a3c4cc29c92" => :yosemite
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
