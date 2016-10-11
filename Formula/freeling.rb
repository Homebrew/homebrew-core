class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.0/FreeLing-4.0.tar.gz"
  sha256 "c79d21c5af215105ba16eb69ee75b589bf7d41abce86feaa40757513e33c6ecf"
  revision 2

  bottle do
    cellar :any
    sha256 "7e903f31687e99d9b3d76408d608d604fb414d1248b57e7a3dbd8865de49db2e" => :sierra
    sha256 "b446bb0c148285eace2423c8dae76fb6e3e2cc5ce261d684faff1590b9905866" => :el_capitan
    sha256 "06f7598a0d56a71af51e59bbac0dffc901911e1431c9702708d820ecdaaf7f0a" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost" => "with-icu4c"
  depends_on "icu4c"

  conflicts_with "hunspell", :because => "both install 'analyze' binary"

  def install
    icu4c = Formula["icu4c"]
    libtool = Formula["libtool"]
    ENV.append "LDFLAGS", "-L#{libtool.lib}"
    ENV.append "LDFLAGS", "-L#{icu4c.lib}"
    ENV.append "CPPFLAGS", "-I#{libtool.include}"
    ENV.append "CPPFLAGS", "-I#{icu4c.include}"

    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}", "--enable-boost-locale"
    system "make", "install"

    libexec.install "#{bin}/fl_initialize"
    inreplace "#{bin}/analyze",
      ". $(cd $(dirname $0) && echo $PWD)/fl_initialize",
      ". #{libexec}/fl_initialize"
  end

  test do
    expected = <<-EOS.undent
      Hello hello NN 1
      world world NN 1
    EOS
    assert_equal expected, pipe_output("#{bin}/analyze -f #{pkgshare}/config/en.cfg", "Hello world").chomp
  end
end
