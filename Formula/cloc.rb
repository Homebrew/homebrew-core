class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/releases/download/1.78/cloc-1.78.tar.gz"
  sha256 "c868926143652377ca68b8b580d0d616066f20fbbd61cdc2be7310d793e734c9"
  head "https://github.com/AlDanial/cloc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6cdda5baedc22ce655e3710c0941bada186684ead1c60501de2d78e5007681e" => :mojave
    sha256 "d1b6fc4ce381936384a97e9481c19f77133bdf7b310dde360d8a548f43c9ad7e" => :high_sierra
    sha256 "ec9ac848b778b9c55ab25f56b4ba12227cfceabdebd424b50e411861f5f54544" => :sierra
    sha256 "dc92ea3a174ca3e27a5e3def7a579a3a87d7e682701c0859306e10d6a250a7b3" => :el_capitan
  end

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz"
    sha256 "ee07853aee06f310e040b6bf1a0199a18d81896d3219b9b35c9630d0eb69089b"
  end

  resource "Algorithm::Diff" do
    url "https://cpan.metacpan.org/authors/id/T/TY/TYEMQ/Algorithm-Diff-1.1903.tar.gz"
    sha256 "30e84ac4b31d40b66293f7b1221331c5a50561a39d580d85004d9c1fff991751"
  end

  resource "Parallel::ForkManager" do
    url "https://cpan.metacpan.org/authors/id/Y/YA/YANICK/Parallel-ForkManager-1.19.tar.gz"
    sha256 "f1de2e9875eeb77d65f80338905dedd522f3913822502982f805aa71cde5a472"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # These are shipped as standard with OS X/macOS' default Perl, but
    # because upstream has chosen to use "#!/usr/bin/env perl" cloc will
    # use whichever Perl is in the PATH, which isn't guaranteed to include
    # these modules. Vendor them to be safe.
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "make", "-C", "Unix", "prefix=#{libexec}", "install"
    bin.install libexec/"bin/cloc"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    man1.install libexec/"share/man/man1/cloc.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "1,C,0,0,4", shell_output("#{bin}/cloc --csv .")
  end
end
