class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v4.4.0/mlr-4.4.0.tar.gz"
  sha256 "d1e7845b90b8ec859bf679cc3ffe90217fbd1aec886d4e88dc9ad0826b2350cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "57ace4fbd7b239c006cb50771a03da548d11e1b290a1e873e575faf19827cb60" => :el_capitan
    sha256 "72f97cce08a5ebed13cf8d2bacb838d8539ba67df4f294d3778267bc5debbcc7" => :yosemite
    sha256 "bce2bab1f80ad3e4febfc1b7081d1a9373e85adca4ff6bdee6044881810ef4a3" => :mavericks
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
