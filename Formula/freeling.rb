class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.0/FreeLing-4.0.tar.gz"
  sha256 "c79d21c5af215105ba16eb69ee75b589bf7d41abce86feaa40757513e33c6ecf"

  bottle do
    cellar :any
    sha256 "8c8d114e2e9c46fa70a0de382f28027ec46380fa3dcd60c0599e9aca56ad9ce3" => :el_capitan
    sha256 "0bb3b2463eaa636cae9a40dba527e3d2e0430eab15b99fee3ed28c4f3b5c6e66" => :yosemite
    sha256 "a9dca2a834ed01f0f4ddad1df10f1b28b80e2760d45c9af272fd1c588316dff6" => :mavericks
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
