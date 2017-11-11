class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/debianutils/debianutils_4.8.3.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/debianutils/debianutils_4.8.3.tar.xz"
  sha256 "7102246d1c35260ed7f0458a9886acf655c379d14908415574494cdea45e28fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbbe1cad0803ad939562c1aa9b39a1284511d6b976c3e464de3b302946e80b12" => :high_sierra
    sha256 "9994c23af4d0d7d72f6a9bc77e68d68111aee06599f0593a83d65a23317698d8" => :sierra
    sha256 "a4bc232d9992f7141db6e4d2805ba4cc6558fdb09a81303c7b66b4d7578889ae" => :el_capitan
    sha256 "52169644003ecf267e64b567d7dbc8d82ea7d90859b30494e5caf56a497b8e31" => :yosemite
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
