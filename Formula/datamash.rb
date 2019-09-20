class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.5.tar.gz"
  sha256 "226249d5fe54024f96404798778f45963a3041714229d4225cd5d9acdaba21ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "d98153d8fa86c50c12ad70c039ed1ab47ca23d8c2753ce1a4c3ffc4181456505" => :mojave
    sha256 "e1f5e1d8108457c23975a13ad65e4e2bff0d4df29009ffc403d69ae70f905a81" => :high_sierra
    sha256 "a99606bdfa15ba2c30a266aca1de086b2c15a470e4cdb1c9a8eb6ba4e978c738" => :sierra
  end

  head do
    url "https://git.savannah.gnu.org/git/datamash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "55", shell_output("seq 10 | #{bin}/datamash sum 1").chomp
  end
end
