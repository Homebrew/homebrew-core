require "language/perl"

class Lcov < Formula
  include Language::Perl::Shebang

  desc "Graphical front-end for GCC's coverage testing tool (gcov)"
  homepage "https://github.com/linux-test-project/lcov"
  url "https://github.com/linux-test-project/lcov/releases/download/v1.16/lcov-1.16.tar.gz"
  sha256 "987031ad5528c8a746d4b52b380bc1bffe412de1f2b9c2ba5224995668e3240b"
  license "GPL-2.0-or-later"
  head "https://github.com/linux-test-project/lcov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e7c3c906dd26501583cf26e1d5d171011f1e216dcf44b49f3d7701cdcf4a53c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fd558cedeedc95fa3bc481a3bde4781c941a63e8c7bb2259bb2e32483f123ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c5d93417fd0352f458241daaebc89c4a67042e4e74c30018e09ee56d15ae832"
    sha256 cellar: :any_skip_relocation, ventura:        "37cdd74962eb81282afb3ce53457ff8afc907615ae474ac00f729ea048c424db"
    sha256 cellar: :any_skip_relocation, monterey:       "8b4c4367f9392015d4448038ec82822d986244f9184f6200fcac7dbbaccd6267"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8f0fb6ec023076edce63a9197bb96a3a3b9a98371c17dbe3e315eaa52de0169"
    sha256 cellar: :any_skip_relocation, catalina:       "7018ff8e61a4229d1ce47e80124ac10f90aa9ed36504798295d0a1a6e4344729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "660d399d6fc26591066767f4514c5c961427afde6bbcb7eb4a853a2b06022adc"
  end

  uses_from_macos "perl"
  uses_from_macos "zlib"

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.06.tar.gz"
    sha256 "1137e98a42208d802f3ad94a10855606c0455ddad167ba018557d751f6f7672e"
  end

  resource "PerlIO::gzip" do
    url "https://cpan.metacpan.org/authors/id/N/NW/NWCLARK/PerlIO-gzip-0.20.tar.gz"
    sha256 "4848679a3f201e3f3b0c5f6f9526e602af52923ffa471a2a3657db786bd3bdc5"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    inreplace %w[bin/genhtml bin/geninfo bin/lcov],
      "/etc/lcovrc", "#{prefix}/etc/lcovrc"
    system "make", "PREFIX=#{prefix}", "BIN_DIR=#{bin}", "MAN_DIR=#{man}", "install"

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    # https://github.com/Homebrew/homebrew-core/issues/4936
    rewrite_shebang detected_perl_shebang, *bin.children

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    gcc = ENV.cc
    gcov = "gcov"

    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main(void)
      {
          puts("hello world");
          return 0;
      }
    EOS

    system gcc, "-g", "-O2", "--coverage", "-o", "hello", "hello.c"
    system "./hello"
    system "#{bin}/lcov", "--gcov-tool", gcov, "--directory", ".", "--capture", "--output-file", "all_coverage.info"

    assert_predicate testpath/"all_coverage.info", :exist?
    assert_includes (testpath/"all_coverage.info").read, testpath/"hello.c"
  end
end
