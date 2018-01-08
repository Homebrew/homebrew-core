class GetIplayer < Formula
  desc "Utility for downloading TV and radio programmes from BBC iPlayer"
  homepage "https://github.com/get-iplayer/get_iplayer"
  url "https://github.com/get-iplayer/get_iplayer/archive/v3.10.tar.gz"
  sha256 "d01eb3247107f2f6a624bbdfa82429554c180af6d87cbe87d9add3ccb3a3ca2e"
  head "https://github.com/get-iplayer/get_iplayer.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "a75e441eb9023faecef7d45c9503c8bca38b9dc7ccf919091214d1a69c0f9408" => :high_sierra
    sha256 "3a2606df6fe2faad107b7ede811f065a84f246901d816053e5ff4ac576c43fd3" => :sierra
    sha256 "c581aa784c34a8649ac4e8a389de0cb15236049f78f3f0685c4021ec2c52796b" => :el_capitan
  end

  depends_on "atomicparsley" => :recommended
  depends_on "ffmpeg" => :recommended

  depends_on :macos => :yosemite

  resource "IO::Socket::IP" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/IO-Socket-IP-0.39.tar.gz"
    sha256 "11950da7636cb786efd3bfb5891da4c820975276bce43175214391e5c32b7b96"
  end

  resource "IO::Socket::SSL" do
    url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.052.tar.gz"
    sha256 "e4897a9b17cb18a3c44aa683980d52cef534cdfcb8063d6877c879bfa2f26673"
  end

  resource "Mojolicious" do
    url "https://cpan.metacpan.org/authors/id/S/SR/SRI/Mojolicious-7.60.tar.gz"
    sha256 "31d1e8a47a7547d6bd64df6725cdf58d2c6e8eb9150dcaf6e2c2e6e368d15c7f"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV["NO_NETWORK_TESTING"] = "1"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    inreplace ["get_iplayer", "get_iplayer.cgi"] do |s|
      s.gsub!(/^(my \$version_text);/i, "\\1 = \"#{pkg_version}-homebrew\";")
      s.gsub! "#!/usr/bin/env perl", "#!/usr/bin/perl"
    end

    bin.install "get_iplayer", "get_iplayer.cgi"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    man1.install "get_iplayer.1"
  end

  test do
    output = shell_output("\"#{bin}/get_iplayer\" --refresh --refresh-include=\"BBC None\" --quiet dontshowanymatches 2>&1")
    assert_match "get_iplayer #{pkg_version}-homebrew", output, "Unexpected version"
    assert_match "INFO: 0 matching programmes", output, "Unexpected output"
    assert_match "INFO: Indexing tv programmes (concurrent)", output,
                         "Mojolicious not found"
  end
end
