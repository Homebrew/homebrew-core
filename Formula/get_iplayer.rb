class GetIplayer < Formula
  desc "Utility for downloading TV and radio programmes from BBC iPlayer"
  homepage "https://github.com/get-iplayer/get_iplayer"
  url "https://github.com/get-iplayer/get_iplayer/archive/v3.24.tar.gz"
  sha256 "d861a002ce40689a5c8d5e5f5b8e261b8c42fed87645d04ff72dd542f58a883e"
  head "https://github.com/get-iplayer/get_iplayer.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e9ffa4537eba77f85744b48de5bd4789690d029fcd776fd2b29b0f7638c704d" => :catalina
    sha256 "29d7dece1a8ebd486c62f370d06dbb17c0283aeef392193492e333f4a8a1cf24" => :mojave
    sha256 "61b7b0a772d0debfcbbdea13ff0b9a24c4f9f9a85245848e1c17b79487cd6aed" => :high_sierra
  end

  depends_on "atomicparsley"
  depends_on "ffmpeg"
  depends_on :macos => :yosemite
  uses_from_macos "libxml2"

  resource "IO::Socket::IP" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/IO-Socket-IP-0.39.tar.gz"
    sha256 "11950da7636cb786efd3bfb5891da4c820975276bce43175214391e5c32b7b96"
  end

  resource "IO::Socket::SSL" do
    url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.066.tar.gz"
    sha256 "0d47064781a545304d5dcea5dfcee3acc2e95a32e1b4884d80505cde8ee6ebcd"
  end

  resource "Mojolicious" do
    url "https://cpan.metacpan.org/authors/id/S/SR/SRI/Mojolicious-7.94.tar.gz"
    sha256 "171a1741f3ea57519657bfb1e40a5290149d7c7d69a1131464c7db23029e8f6e"
  end

  resource "Mozilla::CA" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABH/Mozilla-CA-20180117.tar.gz"
    sha256 "f2cc9fbe119f756313f321e0d9f1fac0859f8f154ac9d75b1a264c1afdf4e406"
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
