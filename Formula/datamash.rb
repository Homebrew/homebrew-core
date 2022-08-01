class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.8.tar.gz"
  sha256 "94a4e11819ad259aa3745b7eca392e385e3a676d276e8cbb616269dbbb17fe6d"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89b84e0e7e30808894613161483b8bb6005561d652522cdc399f1e6d1d00e34a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16e17344961038b0a719392d53f7968053df3680674554c862b0b4f36f4f86c8"
    sha256 cellar: :any_skip_relocation, monterey:       "efb5a8e92a90b49d4784875aff3d2bbeaddf708633a1f7533730979d81354bf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bf80adfcba648b010674056c1abd3cca17a71bd717f81aed0c0d15fbf11abea"
    sha256 cellar: :any_skip_relocation, catalina:       "ffadf24c7def1e77a197952a3e31edbfbb4fc246d373b78c3c0671839d86b422"
    sha256                               x86_64_linux:   "d6937a2c3ab4e5d40b9994e93c8449d2b7231d58b4a7bce60a4866acf946a212"
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
    assert_equal "55", pipe_output("#{bin}/datamash sum 1", shell_output("seq 10")).chomp
  end
end
