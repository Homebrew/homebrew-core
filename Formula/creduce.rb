class Creduce < Formula
  desc "Reduce a C/C++ program while keeping a property of interest"
  homepage "https://embed.cs.utah.edu/creduce/"
  url "https://embed.cs.utah.edu/creduce/creduce-2.10.0.tar.gz"
  sha256 "db1c0f123967f24d620b040cebd53001bf3dcf03e400f78556a2ff2e11fea063"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/csmith-project/creduce.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?creduce[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, monterey: "c03eb4819b85732039da8437bf96f22f9c983a0113f3c7f5811e983c907d8acf"
    sha256 cellar: :any, big_sur:  "885805d75a7b94b42c75993af85ac92b3ac4c3e8a4fdd42e58e4ba14e7b33d48"
    sha256 cellar: :any, catalina: "e6bc0e8e53ccfedfd4423a5b133621d68779b768242b19bef75bfdb4d43ba151"
    sha256 cellar: :any, mojave:   "5f509b134d14e497243bfdd950a148bb50259b0bf8bfd788df9ebaf5823ef96f"
  end

  depends_on "astyle"
  depends_on "delta"
  depends_on "llvm@9"

  uses_from_macos "perl"

  resource "Exporter::Lite" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Exporter-Lite-0.08.tar.gz"
    sha256 "c05b3909af4cb86f36495e94a599d23ebab42be7a18efd0d141fc1586309dac2"
  end

  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.23.tar.gz"
    sha256 "b79dc2244b2d97b6f27167fc3b7799ef61a179040f3abd76ce1e0a3b0bc4e078"
  end

  resource "Getopt::Tabular" do
    url "https://cpan.metacpan.org/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz"
    sha256 "9bdf067633b5913127820f4e8035edc53d08372faace56ba6bfa00c968a25377"
  end

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz"
    sha256 "ee07853aee06f310e040b6bf1a0199a18d81896d3219b9b35c9630d0eb69089b"
  end

  resource "URI::Escape" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/URI-1.72.tar.gz"
      sha256 "35f14431d4b300de4be1163b0b5332de2d7fbda4f05ff1ed198a8e9330d40a32"
    end
  end

  # Use shared libraries.
  # Remove with the next release.
  patch do
    url "https://github.com/csmith-project/creduce/commit/e9bb8686c5ef83a961f63744671c5e70066cba4e.patch?full_index=1"
    sha256 "d5878a2c8fb6ebc5a43ad25943a513ff5226e42b842bb84f466cdd07d7bd626a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # Avoid ending up with llvm's Cellar path hard coded.
    ENV["CLANG_FORMAT"] = Formula["llvm@9"].opt_bin/"clang-format"

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

    (bin/"creduce").write_env_script("#{libexec}/creduce", PERL5LIB: ENV["PERL5LIB"])
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
