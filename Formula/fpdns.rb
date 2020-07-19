class Fpdns < Formula
  desc "Fingerprint DNS server versions"
  homepage "https://github.com/kirei/fpdns"
  url "https://github.com/kirei/fpdns/archive/20190131.tar.gz"
  sha256 "f6599ebed73c2d87d7c2bafc8c3a63fb76bda52478e9a1912410d481f7536100"
  license "BSD-3-Clause"
  head "https://github.com/kirei/fpdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcf157864bccda7f1064856e592acf3b6ef7d46c8dcd48aab66ceae5ef2b394e" => :catalina
    sha256 "dadfa0adfbca40276bc951e541e3d7867d4550fcb552749dca37c95049830a84" => :mojave
    sha256 "0de082e3b044641f04bdc018b5a720c89f1ae3f24340c1bc6bfb88fbe0c3f79f" => :high_sierra
  end

  uses_from_macos "perl"

  resource "Net::DNS" do
    url "https://cpan.metacpan.org/authors/id/N/NL/NLNETLABS/Net-DNS-1.24.tar.gz"
    sha256 "11a6c2ba6cb1c6640f01c9bbf2036bcbe3974232e9b939ab94985230c92cde63"
  end

  resource "Digest::HMAC" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Digest-HMAC-1.03.tar.gz"
    sha256 "3bc72c6d3ff144d73aefb90e9a78d33612d58cf1cd1631ecfb8985ba96da4a59"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make"
    system "make", "install"
    (bin/"fpdns").write_env_script libexec/"bin/fpdns",
      :PERL5LIB => ENV["PERL5LIB"]
  end

  test do
    ENV.prepend_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"
    # First verify that the perl module loads properly
    # This ensures all dependencies are in place
    shell_output "perl -MNet::DNS::Fingerprint -le ''"
    # Now verify the output of the binary
    assert "fingerprint (example.com, ", shell_output("#{bin}/fpdns -D example.com")
  end
end
