class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/v1.70.tar.gz"
  sha256 "fd6e2bf95836578d8e94f2a85ce67f2e0cdf378b8200a02f8ee2a101f45984e9"
  head "https://github.com/AlDanial/cloc.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "02aa44feab6b34f60f68a4fc0fd85e6fe5fadb8b41e266d611839ae49f2f361d" => :sierra
    sha256 "6e6e8a4019474b1249b3c655e5609010888d3642ad8b04a742123d0cb099146c" => :el_capitan
    sha256 "2846be2db9ffb1a7259a261142aa4edac6f6ad01e469e28b19df9c479e058fdd" => :yosemite
    sha256 "cf7a851ac407ecaea3c183b30bb47e549a178bcc7fc5ce145447f162e98db888" => :mavericks
  end

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2016060801.tar.gz"
    sha256 "fc2fc178facf0292974d6511bad677dd038fe60d7ac118e3b83a1ca9e98a8403"
  end

  resource "Algorithm::Diff" do
    url "https://cpan.metacpan.org/authors/id/T/TY/TYEMQ/Algorithm-Diff-1.1903.tar.gz"
    sha256 "30e84ac4b31d40b66293f7b1221331c5a50561a39d580d85004d9c1fff991751"
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
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "1,C,0,0,4", shell_output("#{bin}/cloc --csv .")
  end
end
