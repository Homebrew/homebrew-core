class Creduce < Formula
  desc "Reduce a C/C++ program while keeping a property of interest"
  homepage "https://embed.cs.utah.edu/creduce/"
  revision 2
  head "https://github.com/csmith-project/creduce.git"

  stable do
    url "https://embed.cs.utah.edu/creduce/creduce-2.7.0.tar.gz"
    sha256 "36dca859c97a988e71b1a08e0cbd5849e4da051d248c5e483494194c4a231a41"

    # LLVM 5 compat
    # Fix "error: use of undeclared identifier 'IK_C'" and similar errors
    # Upstream commit from 27 Apr 2017 "Fix build failure with LLVM trunk"
    patch do
      url "https://github.com/csmith-project/creduce/commit/97e2b299.patch?full_index=1"
      sha256 "89197f11c1c32bc234a4ba2102c65b96cc2141286e74cb838189c074c9a750d2"
    end
  end

  bottle do
    cellar :any
    sha256 "f50d414cbfd04ae62ad046a8543b919ff037df60aafe87cd96447600db7d41d6" => :high_sierra
    sha256 "692938f476832e53b257c74c50aa0c873060d80da19fef2ae4ca7850a74a5f30" => :sierra
    sha256 "fdbd90364af6a27ef5c96ca8fd73cdf7d05ede1cdee57efc6fab195caae17ad0" => :el_capitan
    sha256 "d70e409851ded86e436778421c7d2026d09893dba356bd0b3169114c786b1231" => :yosemite
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
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.21.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/P/PL/PLICEASE/File-Which-1.21.tar.gz"
    sha256 "9def5f10316bfd944e56b7f8a2501be1d44c288325309462aa9345e340854bcc"
  end

  resource "Getopt::Tabular" do
    url "https://cpan.metacpan.org/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz"
    sha256 "9bdf067633b5913127820f4e8035edc53d08372faace56ba6bfa00c968a25377"
  end

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2017040401.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/A/AB/ABIGAIL/Regexp-Common-2017040401.tar.gz"
    sha256 "0664c26bb69d7c862849432fde921d4c201fabefd36bff6a9e0996d295053ab8"
  end

  resource "Sys::CPU" do
    url "https://cpan.metacpan.org/authors/id/M/MZ/MZSANFORD/Sys-CPU-0.61.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MZ/MZSANFORD/Sys-CPU-0.61.tar.gz"
    sha256 "250a86b79c231001c4ae71d2f66428092a4fbb2070971acafd471aa49739c9e4"
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
                          "--with-llvm=#{Formula["llvm"].opt_prefix}",
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
