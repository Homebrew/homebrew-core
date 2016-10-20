class Creduce < Formula
  desc "Reduce a C/C++ program while keeping a property of interest"
  homepage "https://embed.cs.utah.edu/creduce/"
  url "https://embed.cs.utah.edu/creduce/creduce-2.5.0.tar.gz"
  sha256 "2dcd784e1d27df60f4ea1d92c4c556c02da4152db353d544dce8b7813fa443e4"
  revision 2

  head "https://github.com/csmith-project/creduce.git"

  bottle do
    cellar :any
    sha256 "ba94a03e5249b8f66db588b7dfea3c67c03fff1a841f3d82b62f1e6d3dd094b7" => :sierra
    sha256 "02dfc1b1598e7de131e1ab6d7f9353f05e329af78fb8d172310562996a7c86d4" => :el_capitan
    sha256 "37f3e7a6e2102138714ceaecd749ee0ddac6bf1d9cb4c5586201e0c840c03951" => :yosemite
  end

  # changes from upstream to fix compilation with LLVM 3.9
  patch do
    url "https://github.com/csmith-project/creduce/commit/377e4f93790690edcd0cde057bb96300aca22858.diff"
    sha256 "1bf6201132dd41953f4c7d454a8f383f432e5a3f2fac416d681bc5e8e8065e18"
  end
  patch do
    url "https://github.com/csmith-project/creduce/commit/d09b8f69419d6c65c7b32675962c9aee813713b5.diff"
    sha256 "995fcb3c5c7aef60ce34ece07a5d225f0bf7886539479988d8b8a6cc0c52de90"
  end

  depends_on "astyle"
  depends_on "delta"
  depends_on "llvm"

  depends_on :macos => :mavericks

  resource "Benchmark::Timer" do
    url "https://cpan.metacpan.org/authors/id/D/DC/DCOPPIT/Benchmark-Timer-0.7107.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DC/DCOPPIT/Benchmark-Timer-0.7107.tar.gz"
    sha256 "64f70fabc896236520bfbf43c2683fdcb0f2c637d77333aed0fd926b92226b60"
  end

  resource "Exporter::Lite" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Exporter-Lite-0.08.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/N/NE/NEILB/Exporter-Lite-0.08.tar.gz"
    sha256 "c05b3909af4cb86f36495e94a599d23ebab42be7a18efd0d141fc1586309dac2"
  end

  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/A/AD/ADAMK/File-Which-1.09.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/A/AD/ADAMK/File-Which-1.09.tar.gz"
    sha256 "b72fec6590160737cba97293c094962adf4f7d44d9e68dde7062ecec13f4b2c3"
  end

  resource "Getopt::Tabular" do
    url "https://cpan.metacpan.org/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz"
    sha256 "9bdf067633b5913127820f4e8035edc53d08372faace56ba6bfa00c968a25377"
  end

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2016060101.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/A/AB/ABIGAIL/Regexp-Common-2016060101.tar.gz"
    sha256 "8d052550e1ddc222f498104f4ce3d56d953e7640b55805c59493060ae6f06815"
  end

  resource "Sys::CPU" do
    url "https://cpan.metacpan.org/authors/id/M/MZ/MZSANFORD/Sys-CPU-0.61.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MZ/MZSANFORD/Sys-CPU-0.61.tar.gz"
    sha256 "250a86b79c231001c4ae71d2f66428092a4fbb2070971acafd471aa49739c9e4"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-llvm=#{Formula["llvm"].opt_prefix}",
                          "--bindir=#{libexec}"
    system "make"
    system "make", "install"

    (bin/"creduce").write_env_script("#{libexec}/creduce", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    (testpath/"test1.c").write <<-EOS.undent
      #include <stdio.h>

      int main() {
        int i = -1;
        unsigned int j = i;
        printf("%d\n", j);
      }

    EOS
    (testpath/"test1.sh").write <<-EOS.undent
      #!/usr/bin/env bash

      clang -Weverything "$(dirname "${BASH_SOURCE[0]}")"/test1.c 2>&1 | \
      grep 'implicit conversion changes signedness'

    EOS

    chmod 0755, testpath/"test1.sh"
    system "#{bin}/creduce", "test1.sh", "test1.c"
  end
end
