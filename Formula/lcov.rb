require "language/perl"

class Lcov < Formula
  include Language::Perl::Shebang

  desc "Graphical front-end for GCC's coverage testing tool (gcov)"
  homepage "https://github.com/linux-test-project/lcov"
  url "https://github.com/linux-test-project/lcov/releases/download/v1.15/lcov-1.15.tar.gz"
  sha256 "c1cda2fa33bec9aa2c2c73c87226cfe97de0831887176b45ee523c5e30f8053a"
  license "GPL-2.0-or-later"
  head "https://github.com/linux-test-project/lcov.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "157d247e5fb878c1b0a4e58387a6f6f868df1e0b1cee820511cad5a34492abd8"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3fe31eeb887f60b1e349c2fa13c09059cc75dbe49471a7da41a5cfc07dc3c01"
    sha256 cellar: :any_skip_relocation, catalina:      "1c84487473440a6f7971ecf25f2b8b5022d23a230d16e863825b43944788e3be"
    sha256 cellar: :any_skip_relocation, mojave:        "41ebe534e6bf4166e88d0eb59ac04d28df457a86fb514fc610ca485386bd06b4"
    sha256 cellar: :any_skip_relocation, high_sierra:   "9c3a3586283d61ae1f1ce30145b613ebdc50e28a7656cf4b4f4e935408f4c147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ebcc60880b409d88b26b9d2b90938997b2ea6c9b0400684d166d920e547004"
  end

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gcc" => :test
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.02.tar.gz"
    sha256 "444a88755a89ffa2a5424ab4ed1d11dca61808ebef57e81243424619a9e8627c"
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
    bin.find { |f| rewrite_shebang detected_perl_shebang, f }

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    gcc = ENV.cc
    gcov = "gcov"

    on_macos do
      gcc_major_ver = Formula["gcc"].any_installed_version.major
      gcc = Formula["gcc"].opt_bin/"gcc-#{gcc_major_ver}"
      gcov = Formula["gcc"].opt_bin/"gcov-#{gcc_major_ver}"
    end

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
