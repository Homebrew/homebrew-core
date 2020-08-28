class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_4.11.1.tar.xz"
  sha256 "8be869f19c55c18d53d9f0414b68bb966a068b2154e9fbbfc6193827d6af983c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://packages.qa.debian.org/d/debianutils.html"
    regex(/href=.*?debianutils[._-]v?(\d+(?:.\d+)+).dsc/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9467ace428a54b279c5c69472a1d83f4c2f62ba7adcf04222546a3f763e396b7" => :catalina
    sha256 "22633540f57bd7b0757b086a5bb150703959941aae875b23875904f5ac3f2eb9" => :mojave
    sha256 "c440b2a9b14c7f4b8b7315af4528ad7bd09b83890b7c40d67109a3a62031d5b5" => :high_sierra
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
