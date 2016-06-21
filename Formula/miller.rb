class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v4.2.0/mlr-4.2.0.tar.gz"
  sha256 "e7495a5de230de2743252124e27edac3d8ff91a2c2dee2166bce31c4b4d1815a"

  bottle do
    cellar :any_skip_relocation
    sha256 "5acfed0c2b9105e515a732341d746913dc65a3b6b2733be98f254eb2485c4ea6" => :el_capitan
    sha256 "f6bacb78c22ab5e2e21b5a4118856942d91f1f1947aee6867a29f893d37813b5" => :yosemite
    sha256 "4d59881cf215c20bbae35642d098118d395193f9080dae461882eb841459f90f" => :mavericks
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
