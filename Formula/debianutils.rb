class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_4.8.6.2.tar.xz"
  sha256 "aca388ba52d19f7c2f7991183a1c15c4d375c692a6cb4bae62cd17b485b10bba"

  bottle do
    cellar :any_skip_relocation
    sha256 "d34836dcdb11d0fc332d8f4daa871279f1e88d50a1948b51d2de81241fd83cc6" => :mojave
    sha256 "842f6907d6005f4379bbef6eaedaf749c37c3d2179447b80e3239b99ee864deb" => :high_sierra
    sha256 "c530b6e5122e115c6d95120c2477a37e6bfc06a84cceac7e134d4c2aeb5407bb" => :sierra
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
