class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_4.10.tar.xz"
  sha256 "bd6e39a563cd8169bad76df80a4782f151f7213a2ebce84940237f54798642d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "49c760f562c361b8d376f6d5787efde6ca4d16c20716143585f0fb717d37a087" => :catalina
    sha256 "8cd65dd6b938fcdd97c7f5f507e610ce3823ba5b5bde178db5f6c6ec01ae4a71" => :mojave
    sha256 "6d2c992bc7eef974fa56c8ab43bcb2ea487c3128b53fa4e11bac005e2c30c6f8" => :high_sierra
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
