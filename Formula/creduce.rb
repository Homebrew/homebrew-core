class Creduce < Formula
  desc "Reduce a C/C++ program while keeping a property of interest"
  homepage "https://embed.cs.utah.edu/creduce/"
  url "https://embed.cs.utah.edu/creduce/creduce-2.8.0.tar.gz"
  sha256 "77f622453a7fc52aa061a89aed457f23ab538b12270df0a2a79b6957fd381def"
  head "https://github.com/csmith-project/creduce.git"

  bottle do
    cellar :any
    sha256 "fbf09e354c9e1da58a93153eade303df094affe643e52422abb3795971723c79" => :high_sierra
    sha256 "f2e4746773e42becc90d3068eaf9aee64701a51dab6349ea44947a88c128b0ee" => :sierra
    sha256 "667d3b67033eb93718a83f63eede85f1d48965e2cb729d4ddb33f655c485c936" => :el_capitan
  end

  depends_on "astyle"
  depends_on "delta"
  depends_on "llvm"

  depends_on :macos => :mavericks

  resource "Exporter::Lite" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Exporter-Lite-0.08.tar.gz"
    sha256 "c05b3909af4cb86f36495e94a599d23ebab42be7a18efd0d141fc1586309dac2"
  end

  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.22.tar.gz"
    sha256 "e8a8ffcf96868c6879e82645db4ff9ef00c2d8a286fed21971e7280f52cf0dd4"
  end

  resource "Getopt::Tabular" do
    url "https://cpan.metacpan.org/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz"
    sha256 "9bdf067633b5913127820f4e8035edc53d08372faace56ba6bfa00c968a25377"
  end

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz"
    sha256 "ee07853aee06f310e040b6bf1a0199a18d81896d3219b9b35c9630d0eb69089b"
  end

  resource "Term::ReadKey" do
    url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.37.tar.gz"
    sha256 "4a9383cf2e0e0194668fe2bd546e894ffad41d556b41d2f2f577c8db682db241"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # Avoid ending up with llvm's Cellar path hard coded.
    ENV["CLANG_FORMAT"] = Formula["llvm"].opt_bin/"clang-format"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--bindir=#{libexec}"
    system "make"
    system "make", "install"

    (bin/"creduce").write_env_script("#{libexec}/creduce", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    (testpath/"test1.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int i = -1;
        unsigned int j = i;
        printf("%d\n", j);
      }

    EOS
    (testpath/"test1.sh").write <<~EOS
      #!/usr/bin/env bash

      clang -Weverything "$(dirname "${BASH_SOURCE[0]}")"/test1.c 2>&1 | \
      grep 'implicit conversion changes signedness'

    EOS

    chmod 0755, testpath/"test1.sh"
    system "#{bin}/creduce", "test1.sh", "test1.c"
  end
end
