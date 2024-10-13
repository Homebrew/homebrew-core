class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz"
  sha256 "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d9228ebaa793d92c595330933bae23f35eef1d8ecc2748b1491d1492cf8aa98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abc5750010dbf09e17cad13f74162ce621f12f731e90841e613b805927146b1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32325a1ebd1bb1e3254db3e55109102a0ccdf9ee4574af862096db23596ac84c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d49fad80145a196ee2546d8de14ed565a7b9f56038c6b1c323aa0fc1e1344fbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a7f69bdcdf93c52175a00c985059d65ef662331d52162d3bc66b5179e924be8"
    sha256 cellar: :any_skip_relocation, ventura:        "89ed0963847169a29ff1f651c1e6aa7dad231b1c3dd31d4780987ef88e28afd2"
    sha256 cellar: :any_skip_relocation, monterey:       "c062154f9f17fe3002232fa03dd75a4d6215f376964b6ff3628a61fed824ecf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "876f84653f0c11dfe42194d77094ae883520e76a6c0cdf741ea7fa52afa749a7"
  end

  uses_from_macos "perl"

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
    system "make", "install"
  end

  test do
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5" if OS.linux?
    system "perl", "-e", "require XML::Parser;"
  end
end
