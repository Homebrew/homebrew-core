class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/moreutils/moreutils_0.58.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/moreutils/moreutils_0.58.orig.tar.gz"
  sha256 "9c4bba745518f1cc4d5594b1276793bd4f737fedb2e5b14beeab4b73f106c00a"

  head "git://git.kitenet.net/moreutils"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbe3a3e2b61398a699da4de280baf7afb3a6a4cca3403195abc51af0b04b7834" => :el_capitan
    sha256 "7530db1d5cb7b02d06085ebfc6377418a158f12f9e9c774d66aefba9148d1d36" => :yosemite
    sha256 "c05d7423cac183a57a3bc415283789725516c64389e13aa933504416f7f8e9fd" => :mavericks
  end

  option "without-parallel", "Build without the 'parallel' tool."

  depends_on "docbook-xsl" => :build

  conflicts_with "parallel", :because => "Both install a 'parallel' executable."
  conflicts_with "task-spooler", :because => "Both install a 'ts' executable."

  resource "Time::Duration" do
    url "https://cpan.metacpan.org/authors/id/A/AV/AVIF/Time-Duration-1.1.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/A/AV/AVIF/Time-Duration-1.1.tar.gz"
    sha256 "a69c419c4892f21eba10002e2ab8c55b657b6691cf6873544ef99ef5fd188f4e"
  end

  resource "IPC::Run" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IPC-Run-0.92.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/IPC-Run-0.92.tar.gz"
    sha256 "e186b46ddf1577d24f11eec1ba42285963c3f71ec7ecb1ce51d6e88c729d46d2"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("Time::Duration").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "--skipdeps"
      system "make", "install"
    end

    resource("IPC::Run").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    inreplace "Makefile",
              "/usr/share/xml/docbook/stylesheet/docbook-xsl",
              "#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    if build.without? "parallel"
      inreplace "Makefile", /^BINS=.*\Kparallel/, ""
      inreplace "Makefile", /^MANS=.*\Kparallel\.1/, ""
    end
    system "make", "all"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    pipe_output("#{bin}/isutf8", "hello", 0)
    pipe_output("#{bin}/isutf8", "\xca\xc0\xbd\xe7", 1)
  end
end
