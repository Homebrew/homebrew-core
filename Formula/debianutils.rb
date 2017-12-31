class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/debianutils/debianutils_4.8.4.tar.xz"
  sha256 "c061ab99aea61f892043b7624b021ab5b193e9c6bbfd474da0fbcdd506be1eb2"

  bottle do
    cellar :any_skip_relocation
    sha256 "e69ed2b8db267b01c61f0e792c2276f2f3cb92c31e5fdb4d6fedcd189756b999" => :high_sierra
    sha256 "3e1bef16feab858fc42c7f2062551e3124c5bb437e0c4da7d2d5427a03fd6177" => :sierra
    sha256 "a04d91df71d97539e30d53850f38f18fa6e72795ab88ca0d0d27568739b77228" => :el_capitan
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
