class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/debianutils/debianutils_4.8.4.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/debianutils/debianutils_4.8.4.tar.xz"
  sha256 "c061ab99aea61f892043b7624b021ab5b193e9c6bbfd474da0fbcdd506be1eb2"

  bottle do
    cellar :any_skip_relocation
    sha256 "9993f2f595a8d2e7af08ebf4714d60c28033c6ebca36a749bdbf3c37132734ca" => :high_sierra
    sha256 "979a2f4b64472fc890fb6cec060bcde6669cbaebac77dd40d12a590ebc790f80" => :sierra
    sha256 "44dd6d68e4a150df8eea8ab3c3459574d0971dc59544e42d4f348e659b45dceb" => :el_capitan
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
    output = shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip
    assert_predicate Pathname.new(output), :exist?
  end
end
