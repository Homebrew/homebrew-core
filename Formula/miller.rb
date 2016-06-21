class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v4.2.0/mlr-4.2.0.tar.gz"
  sha256 "e7495a5de230de2743252124e27edac3d8ff91a2c2dee2166bce31c4b4d1815a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9797ffb7e265e21ebbd5e75e1fec994c9f263c10388b1b783321c7f9be67fd9" => :el_capitan
    sha256 "e9045c345fc41716d21922eff347d851e86c13386095d05aca76f8ef937318aa" => :yosemite
    sha256 "20b8e15eecd7756be6a7fcbdf1aaf55fbd9307cca47e628856a860415879c27f" => :mavericks
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
