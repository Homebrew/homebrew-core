class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/git/moreutils.git",
      :tag      => "0.63",
      :revision => "aeddd0f4caa9d10aaa691040773fa4764e12ff46"
  head "https://git.joeyh.name/git/moreutils.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0277b44f53cc7e581c338a28fa330e4d436cd05757d99cfc9baa1f5ca095af4c" => :catalina
    sha256 "a3d5a342bf079998b52d172f0f5e8b066b256145e2eb3ded393a0e6e2680b573" => :mojave
    sha256 "3731c1304a72a7a0486891bf592cd82b7422d0c37cadeb00b6f633e62f20aa35" => :high_sierra
    sha256 "fac2ba67a62889ff07edb8257e0d13aa96143a7421521ffdf3e0cf685a1cdc1e" => :sierra
  end

  depends_on "docbook-xsl" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build

  conflicts_with "parallel", :because => "Both install a `parallel` executable."
  conflicts_with "pwntools", :because => "Both install an `errno` executable."
  conflicts_with "task-spooler", :because => "Both install a `ts` executable."

  resource "Time::Duration" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Time-Duration-1.20.tar.gz"
    sha256 "458205b528818e741757b2854afac5f9af257f983000aae0c0b1d04b5a9cbbb8"
  end

  resource "IPC::Run" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IPC-Run-0.94.tar.gz"
    sha256 "2eb336c91a2b7ea61f98e5b2282d91020d39a484f16041e2365ffd30f8a5605b"
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

    inreplace "Makefile" do |s|
      s.gsub! "/usr/share/xml/docbook/stylesheet/docbook-xsl",
              "#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    end
    system "make", "all"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    pipe_output("#{bin}/isutf8", "hello", 0)
    pipe_output("#{bin}/isutf8", "\xca\xc0\xbd\xe7", 1)
  end
end
