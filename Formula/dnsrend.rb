class Dnsrend < Formula
  desc "DNS message dissector"
  homepage "https://lecter.redbrick.dcu.ie/dnsrend/"
  url "https://lecter.redbrick.dcu.ie/software/dnsrend-0.08.tar.gz"
  sha256 "32fa6965f68e7090af7e4a9a06de53d12f40397f644a76cf97b6b4cb138da93a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cf8bef7e88c3b75779c9606cec113e06be610633df88c3aad2a73a4ba96c10c2" => :catalina
    sha256 "50426241b5ffb70ce749cb114c48927fbada7082264daa232c79b0dc6e293e7c" => :mojave
    sha256 "6db5eb20d3b550e317c0fd51d2dea70688db5663f83b1ac3146e99f74aced1cc" => :high_sierra
    sha256 "ff7281e230ada3a6ebf6ec6b46f5a0a5b28597c2f817cf99df9b2b32c3f175b7" => :sierra
    sha256 "fd38fc65be2c773804e6b7713cabee7fbdbc9ac344e72382e36174aaf258a41f" => :el_capitan
    sha256 "83519cb5e7899fa2d2eca7f2a0e4ff76336582206ac42063ad1a446612bf3471" => :yosemite
    sha256 "d9f91e7344b0457ec4d0ab29c95a91bf91c4c8d3ee8432b4159b1818785c043f" => :mavericks
  end

  resource "Net::Pcap" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SAPER/Net-Pcap-0.17.tar.gz"
    sha256 "aaee41ebea17924abdc2d683ec940b3e6b0dc1e5e344178395f57774746a5452"
  end

  resource "Net::Pcap::Reassemble" do
    url "https://cpan.metacpan.org/authors/id/J/JR/JRAFTERY/Net-Pcap-Reassemble-0.04.tar.gz"
    sha256 "0bcba2d4134f6d412273a75663628b08b0a164e0a5ecb8a2fd14cdf5237629c4"
  end

  def install
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    libexec.install "dnsrend"
    doc.install "README"

    (bin/"dnsrend").write <<~EOS
      #!/bin/sh
      /usr/bin/env perl -Tw -I "#{libexec}/lib/perl5" #{libexec}/dnsrend "$@"
    EOS
  end

  test do
    system "#{bin}/dnsrend", test_fixtures("test.pcap")
  end
end
