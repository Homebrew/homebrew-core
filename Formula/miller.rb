class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v4.3.0/mlr-4.3.0.tar.gz"
  sha256 "4a934014bc15e96481270d0537d4cec8c7147a5edf2750d9c20957bdf31699fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "57c27b17711cfbce2b6a97231de088c8379372c1a8f5c1f8af1fe2f9dcfd0b44" => :el_capitan
    sha256 "601b9a334d89a35782c0b7b4576045adcc96aa31b5b563babd8238bebca87878" => :yosemite
    sha256 "2f9e4bceefe7ef0d12de9227891704ff5758780acffd4856d198e399f213fa49" => :mavericks
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
