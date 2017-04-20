class Creduce < Formula
  desc "Reduce a C/C++ program while keeping a property of interest"
  homepage "https://embed.cs.utah.edu/creduce/"
  revision 2
  head "https://github.com/csmith-project/creduce.git"

  stable do
    url "https://embed.cs.utah.edu/creduce/creduce-2.6.0.tar.gz"
    sha256 "cdacc1046ca3ae2b0777b8f235428e7976b0fb97c2f69979c8accd8d2cc0c55d"

    # Remove for > 2.6.0
    # LLVM 4.0 compatibility
    # Upstream commit "clang_delta: Namespace-qualify clang::StringLiteral"
    # Upstream PR from 19 Dec 2016 https://github.com/csmith-project/creduce/pull/128
    patch do
      url "https://github.com/csmith-project/creduce/commit/ba1b8a6.patch"
      sha256 "c55148fc8f8d2b2e39ed25041b1335c8223185969656e4effa336cae9c7b671c"
    end
  end

  bottle do
    cellar :any
    sha256 "2814d1c9272c27202e5e001222516d21449421cd224ea80c710868af19f214bc" => :sierra
    sha256 "cbbd2e1b8f6865be02a30a75415cc97d81b1753607e1b1945a37ca01fe55aa14" => :el_capitan
    sha256 "053118df03aeec8dddc8fa270797dec3d4b875f9f7f288e8731e7c9d3f7d0439" => :yosemite
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
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2016060801.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/A/AB/ABIGAIL/Regexp-Common-2016060801.tar.gz"
    sha256 "fc2fc178facf0292974d6511bad677dd038fe60d7ac118e3b83a1ca9e98a8403"
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
