class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/1.84.tar.gz"
  sha256 "b88a3adc669c15a9a32975095090708ba4eee5a73b8498369fae14be5b8a37d4"
  head "https://github.com/AlDanial/cloc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "133bacc497cb73a958e823f12e09e91b97d43ac188e4b002e7f939c5625fcacd" => :catalina
    sha256 "faa85a918f0517f35a41fb60550c0d990ed58aed325c50efca95634b014edbd8" => :mojave
    sha256 "0407f6ec4d2378659b63bb33598f9b5f49756325322fe3fc0f339ec16b5edc5f" => :high_sierra
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
    url "https://cpan.metacpan.org/authors/id/Y/YA/YANICK/Parallel-ForkManager-2.02.tar.gz"
    sha256 "c1b2970a8bb666c3de7caac4a8f4dbcc043ab819bbc337692ec7bf27adae4404"
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
