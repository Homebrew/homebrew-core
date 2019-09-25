class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.6.0/mlr-5.6.0.tar.gz"
  sha256 "325f9acabd5b1b00663b03c6454f609981825ba12d3f82d000772399a28a1ff2"

  bottle do
    cellar :any_skip_relocation
    sha256 "a16659cfdc72dfde05634aa03155535ba8b5ae720864838606df5d47bb59a8bc" => :mojave
    sha256 "39ff0c316f56bed553a9da632c3f791c2651550ffa8d27d57d3b0ce1cd9f4481" => :high_sierra
    sha256 "79155a7c2dd70813d51c99df37719ea29013ee4814e887eeced45f437c342369" => :sierra
  end

  head do
    url "https://github.com/johnkerl/miller.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
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
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match /a\n1\n4\n/, output
  end
end
