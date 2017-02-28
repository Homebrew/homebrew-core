class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.0.0/mlr-5.0.0.tar.gz"
  sha256 "f2dbcf84492ad2bdd520e07abc8b5274a1959fb219a075adb66d1f8d2d1d8917"

  bottle do
    cellar :any_skip_relocation
    sha256 "3526727329df7caa90bd79af1d0a507e25f8d37f497aefbbc195e3e95f966f40" => :sierra
    sha256 "21ad852a4e442347a56f9544e6bc37a19e5ec6da408546965eabcfae4731c6d4" => :el_capitan
    sha256 "b1c960a061390e0c2dd3126529cd03d79858358279fa3014f2515755abd6f1ba" => :yosemite
    sha256 "3a1d0ec591312b790a6cd669b9b724adef11ceb9264cc68d66fda9eed08ebb9a" => :mavericks
  end

  head do
    url "https://github.com/johnkerl/miller.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<-EOS.undent
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match /a\n1\n4\n/, output
  end
end
