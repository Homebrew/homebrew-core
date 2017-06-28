class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/debianutils/debianutils_4.8.1.1.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/debianutils/debianutils_4.8.1.1.tar.xz"
  sha256 "06446cd4c0d309fd31a0682c5c2f07f7613fb867f769414b9cc51f155ad73172"

  bottle do
    cellar :any_skip_relocation
    sha256 "25750c7137e1017c68a504c8d50be6cf45e281d16431cb712a1e9d10c0cd7bc4" => :sierra
    sha256 "b7c94594e2e103e491779a5872049e28373b1e039914574623ade0c893a65b8a" => :el_capitan
    sha256 "fe3cc3649ac7cda8b062b947f89df3844809f6b041b3c22510f70271b09ed7ce" => :yosemite
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
