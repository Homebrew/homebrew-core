class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.0/FreeLing-4.0.tar.gz"
  sha256 "c79d21c5af215105ba16eb69ee75b589bf7d41abce86feaa40757513e33c6ecf"
  revision 5

  bottle do
    cellar :any
    sha256 "a10e9d27a296b3ea70d16161ea9ce18cd8491c738793fea431dd342361d18c75" => :sierra
    sha256 "e0bf5748d9bc47ddb73e1ee4fc2d036ddf2c8cda55f0d80300e9605f845b7a2b" => :el_capitan
    sha256 "20adbce75d8949abd8bedeef59e9867331b6eb59579c3a92e831bb1eca0ccb1f" => :yosemite
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
