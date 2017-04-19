class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "https://joeyh.name/code/moreutils/"
  url "git://git.joeyh.name/moreutils",
      :tag => "0.61",
      :revision => "01d1b22f22fae647cbfd855dc82f8d9548607ab0"
  head "git://git.joeyh.name/moreutils"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae130c5fa715e6c9cf338201f5318f58bfa98910b67b26bcf4f68a247dc36083" => :sierra
    sha256 "b9865588c4d434d5e35d19cdf2b39b36031d6b6cd77835e182fd5e76fa7cba48" => :el_capitan
    sha256 "b39209ebca05c0aa733dbf01c615be42db78f9438431e82df52f7f3914c9788a" => :yosemite
    sha256 "512b618f6a652f673485616677c6207a8645a3dcfe98b619787e58c3cb5a5811" => :mavericks
  end

  option "without-parallel", "Build without the 'parallel' tool."
  option "without-errno", "Build without the 'errno' tool, for compatibility with 'pwntools'."
  option "without-ts", "Build without the 'ts' tool, for compatibility with 'task-spooler'."

  depends_on "docbook-xsl" => :build

  conflicts_with "parallel", :because => "Both install a `parallel` executable." if build.with? "parallel"
  conflicts_with "pwntools", :because => "Both install an `errno` executable." if build.with? "errno"
  conflicts_with "task-spooler", :because => "Both install a `ts` executable." if build.with? "ts"

  resource "Time::Duration" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Time-Duration-1.20.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/N/NE/NEILB/Time-Duration-1.20.tar.gz"
    sha256 "458205b528818e741757b2854afac5f9af257f983000aae0c0b1d04b5a9cbbb8"
  end

  resource "IPC::Run" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IPC-Run-0.94.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/IPC-Run-0.94.tar.gz"
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
      %w[parallel errno ts].each do |util|
        next if build.with? util
        s.gsub! /^BINS=.*\K#{util}/, "", false
        s.gsub! /^MANS=.*\K#{util}\.1/, ""
        s.gsub! /^PERLSCRIPTS=.*\K#{util}/, "", false
      end
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
