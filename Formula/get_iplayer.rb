class GetIplayer < Formula
  desc "Utility for downloading TV and radio programmes from BBC iPlayer"
  homepage "https://github.com/get-iplayer/get_iplayer"
  url "https://github.com/get-iplayer/get_iplayer/archive/v3.18.tar.gz"
  sha256 "e26ed3bd6db36263dddfefa1c000b541c97cd2338f3376d6952cccab2de71cd7"
  head "https://github.com/get-iplayer/get_iplayer.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "02ea2ac638c368a3481b0d1a329c093dd3033c28451ac9042c1c50902f0d5825" => :mojave
    sha256 "61a148a03e05ca6e8139a495632eec70299c89c117677364cf3d0a35d3a6520a" => :high_sierra
    sha256 "bdbdcc3d392f25007dccfcd8222008924da110d7cac95f02bc6e56652e21dab6" => :sierra
  end

  depends_on "atomicparsley"
  depends_on "ffmpeg"
  depends_on :macos => :yosemite

  resource "IO::Socket::IP" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/IO-Socket-IP-0.39.tar.gz"
    sha256 "11950da7636cb786efd3bfb5891da4c820975276bce43175214391e5c32b7b96"
  end

  resource "IO::Socket::SSL" do
    url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.059.tar.gz"
    sha256 "217debbe0a79f0b7c5669978b4d733271998df4497f4718f78456e5f54d64849"
  end

  resource "Mojolicious" do
    url "https://cpan.metacpan.org/authors/id/S/SR/SRI/Mojolicious-7.93.tar.gz"
    sha256 "00c30fc566fee0823af0a75bdf4f170531655df14beca6d51f0e453a43aaad5d"
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
