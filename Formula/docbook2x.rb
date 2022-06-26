class Docbook2x < Formula
  desc "Convert DocBook to UNIX manpages and GNU TeXinfo"
  homepage "https://docbook2x.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/docbook2x/docbook2x/0.8.8/docbook2X-0.8.8.tar.gz"
  sha256 "4077757d367a9d1b1427e8d5dfc3c49d993e90deabc6df23d05cfe9cd2fcdc45"

  livecheck do
    url :stable
    regex(%r{url=.*?/docbook2X[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3012b908f1a415b3ff679474eb15f97842b96eb61a03ba8d4c68f83c0a9dfba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88732999a070c6a9f609c5740fcdf7ed6c014be05555a9aea867e1a69b71aeec"
    sha256 cellar: :any_skip_relocation, monterey:       "3c4bec297dbc2c767f605b1f769bdc1f8b7401f38f267e90365f592902db5ebf"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a9d1f18cb66569bdebd729119d64719a8e4990ceab99a10a395d61eea3217ae"
    sha256 cellar: :any_skip_relocation, catalina:       "a7562a999301c0879be6f39bd031bb886e68ca56c8aca08b1977eaf1e2927496"
    sha256 cellar: :any_skip_relocation, mojave:         "2009056af30fb2a08a751e055fbdec14d49b4bc51da34cb63737b22b4b4d7784"
    sha256 cellar: :any_skip_relocation, high_sierra:    "81734088203909fc5db96462d14116596058910cd1b7ab67389a7bf93c9bae63"
    sha256 cellar: :any_skip_relocation, sierra:         "a1110d4bd90cecf9ce8edacc27a3edc84dfcd4db7ab50b67269af0eb6a9bb00a"
    sha256 cellar: :any_skip_relocation, el_capitan:     "acfdd1c80cb523b213dea0125819b1b6fc783d6d740cc8fc0047f44756b57889"
    sha256 cellar: :any_skip_relocation, yosemite:       "e3efe4afe190e126174c6e3bec0a9feb4ad37ddd0ecaef778b1e8df8a60e8717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e054b07a0d7e8817a58b2c656e8f435289cd1d2110d7fae083e1bf79eece522"
  end

  depends_on "docbook"

  uses_from_macos "libxslt"
  uses_from_macos "perl"

  on_linux do
    resource "XML::NamespaceSupport" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz"
      sha256 "47e995859f8dd0413aa3f22d350c4a62da652e854267aa0586ae544ae2bae5ef"
    end
    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
    resource "XML::SAX::Exception" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz"
      sha256 "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0"
    end
    resource "XML::SAX::ParserFactory" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-1.02.tar.gz"
      sha256 "4506c387043aa6a77b455f00f57409f3720aa7e553495ab2535263b4ed1ea12a"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end
    end

    inreplace "perl/db2x_xsltproc.pl", "http://docbook2x.sf.net/latest/xslt", "#{share}/docbook2X/xslt"
    inreplace "configure", "${prefix}", prefix
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"] if OS.linux?
  end

  test do
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    (testpath/"brew.1.xml").write <<~EOS
      <?xml version="1.0" encoding="ISO-8859-1"?>
      <!DOCTYPE refentry PUBLIC "-//OASIS//DTD DocBook XML V4.4//EN"
                         "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd">
      <refentry id='brew1'>
      <refmeta>
        <refentrytitle>brew</refentrytitle>
        <manvolnum>1</manvolnum>
      </refmeta>
      <refnamediv>
        <refname>brew</refname>
        <refpurpose>The missing package manager for macOS</refpurpose>
      </refnamediv>
      </refentry>
    EOS
    system bin/"docbook2man", testpath/"brew.1.xml"
    assert_predicate testpath/"brew.1", :exist?, "Failed to create man page!"
  end
end
