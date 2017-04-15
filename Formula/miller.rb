class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.1.0/mlr-5.0.1.tar.gz"
  sha256 "a7c933149b19f0c38a7e5e52c18dcb1dd200dd714adfadbf0a12756f3ed6c17c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9b419fe64059e0343a6e8c084c2c53b373eb9b5518aa9e9e5d03ead15893274" => :sierra
    sha256 "c225ca27bee443385dfced79cabaa4466a918544d1e5298425158517d46d0249" => :el_capitan
    sha256 "b3047b6e571a4f31c389211cb916ee0def2fcc1b1e3fc0ecbfaf979be102af23" => :yosemite
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
