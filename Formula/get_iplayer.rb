class GetIplayer < Formula
  desc "Utility for downloading TV and radio programmes from BBC iPlayer"
  homepage "https://github.com/get-iplayer/get_iplayer"
  url "https://github.com/get-iplayer/get_iplayer/archive/v3.12.tar.gz"
  sha256 "30070d2b0479abd701444169860f338668321548175d43e02bc6bc18adeee51c"
  head "https://github.com/get-iplayer/get_iplayer.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6f04e6b0032c7c33142088a0cb4b755fc8fde8323f3cbec6e9f43bf6b78f526" => :high_sierra
    sha256 "e9c4aaa855e32cd7dbaeae1c925c422c539e66d8df8197efdcf524dd6ec1580a" => :sierra
    sha256 "cf32813d2eb1c49a7a5af90429258738ce5c887fda17e528e0263a312758ccdc" => :el_capitan
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
