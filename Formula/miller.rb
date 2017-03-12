class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.0.1/mlr-5.0.1.tar.gz"
  sha256 "64d9c16bf9d6ef45f22ef43a6652f784ecd2b629004f03dfd1c6dd9572377150"

  bottle do
    cellar :any_skip_relocation
    sha256 "35732d8c77350447481df3f67b98fecbd664ab2b4a6f02bf9819f05517214066" => :sierra
    sha256 "cdc5494549d3d1ead4c9244e7c09b795e630bbb4d9745f84784dd9adcc226063" => :el_capitan
    sha256 "756aebf1774639a016c52f23f6b82293f2adb6a7d9fecaef50261d11d8d48408" => :yosemite
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
