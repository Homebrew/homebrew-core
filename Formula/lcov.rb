class Lcov < Formula
  desc "Graphical front-end for GCC's coverage testing tool (gcov)"
  homepage "https://github.com/linux-test-project/lcov"
  url "https://github.com/linux-test-project/lcov/releases/download/v1.14/lcov-1.14.tar.gz"
  sha256 "14995699187440e0ae4da57fe3a64adc0a3c5cf14feab971f8db38fb7d8f071a"
  revision 2
  head "https://github.com/linux-test-project/lcov.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b21ae046fb2ea8d55d55b5a2c6b0286a7fc046dba89b14bf84f8454451c83db7" => :catalina
    sha256 "f06ff8fa92f115d51d046e910036559bd93b03793c6622ed23e67051528917a6" => :mojave
    sha256 "9553c52a9ca708173708d13f56e763f136e35504e8202147fec8ba8604399181" => :high_sierra
  end

  depends_on "gcc" => :test

  uses_from_macos "perl"

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.02.tar.gz"
    sha256 "444a88755a89ffa2a5424ab4ed1d11dca61808ebef57e81243424619a9e8627c"
  end

  resource "PerlIO::gzip" do
    url "https://cpan.metacpan.org/authors/id/N/NW/NWCLARK/PerlIO-gzip-0.20.tar.gz"
    sha256 "4848679a3f201e3f3b0c5f6f9526e602af52923ffa471a2a3657db786bd3bdc5"
  end

  # The following 2 patches fix compatibiliry with gcc-9
  # Remove in the next release
  patch do
    url "https://github.com/linux-test-project/lcov/commit/ebfeb3e179e450c69c3532f98cd5ea1fbf6ccba7.patch?full_index=1"
    sha256 "83d380e753eda054d73da08774e9ca01aa642440ffb93a0f8f3d1ac81e35d006"
  end

  patch do
    url "https://github.com/linux-test-project/lcov/commit/75fbae1cfc5027f818a0bb865bf6f96fab3202da.patch?full_index=1"
    sha256 "72cf3f356a4ac0ff98a66ef7bc085b5be3b41f155decc9ef4eca8ec140840e7f"
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
    perl_files = Dir["#{bin}/*"]
    inreplace perl_files, "#!/usr/bin/env perl", "#!/usr/bin/perl"

    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    gcc = Formula["gcc"].opt_bin/"gcc-#{Formula["gcc"].version_suffix}"
    gcov = Formula["gcc"].opt_bin/"gcov-#{Formula["gcc"].version_suffix}"

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
    assert_include (testpath/"all_coverage.info").read, testpath/"hello.c"
  end
end
