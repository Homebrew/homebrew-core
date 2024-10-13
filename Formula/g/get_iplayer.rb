class GetIplayer < Formula
  desc "Utility for downloading TV and radio programmes from BBC iPlayer"
  homepage "https://github.com/get-iplayer/get_iplayer"
  url "https://github.com/get-iplayer/get_iplayer/archive/refs/tags/v3.35.tar.gz"
  sha256 "048ff5f9bd5c6c0f51a05fd0c97eb137029d1950b594384a920c3c674f121e8c"
  license "GPL-3.0-or-later"
  head "https://github.com/get-iplayer/get_iplayer.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f1c79e1af002a808fb4f42e10dff6358dfca0838e4a7de585e909a86eb30f82d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa7b3acc3812e519bf72aacdda6cffd84d7f19e07a39a220e4f10d570675d8fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "065d0cef0fb0834145ea1b794f540be554de639404a2849f6f62d425349b3fe2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "065d0cef0fb0834145ea1b794f540be554de639404a2849f6f62d425349b3fe2"
    sha256 cellar: :any_skip_relocation, sonoma:         "80e39e9e718785e13d5f737f8c0ca86b2f64657307d69f05ee08cccb51ca076f"
    sha256 cellar: :any_skip_relocation, ventura:        "f88939072c58bc84a1badf03210a4fb1eacfb84540eb7296eb7b40218e8e87df"
    sha256 cellar: :any_skip_relocation, monterey:       "f88939072c58bc84a1badf03210a4fb1eacfb84540eb7296eb7b40218e8e87df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3948f275bf3d1142d6136f8ded46abe7601f1bd8300e8a5f01265770b3de350c"
  end

  depends_on "atomicparsley"
  depends_on "ffmpeg"

  uses_from_macos "libxml2"
  uses_from_macos "perl"

  on_linux do
    depends_on "openssl@3"

    resource "Try-Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.30.tar.gz"
      sha256 "da5bd0d5c903519bbf10bb9ba0cb7bcac0563882bcfe4503aee3fb143eddef6b"
    end

    resource "Path:Class" do
      url "https://cpan.metacpan.org/authors/id/K/KW/KWILLIAMS/Path-Class-0.33.tar.gz"
      sha256 "cd8cc6a68e2099eeb6099df6af83b4585eb0ddf6c77490d6fa97eadb09d0c677"
    end

    resource "Net::HTTP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.18.tar.gz"
      sha256 "7e42df2db7adce3e0eb4f78b88c450f453f5380f120fd5411232e03374ba951c"
    end

    resource "Net::SSLeay" do
      url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.88.tar.gz"
      sha256 "2000da483c8471a0b61e06959e92a6fca7b9e40586d5c828de977d3d2081cfdd"
    end

    resource "HTML::Entities" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTML-Parser-3.72.tar.gz"
      sha256 "ec28c7e1d9e67c45eca197077f7cdc41ead1bb4c538c7f02a3296a4bb92f608b"
    end

    resource "HTTP::Cookies" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.04.tar.gz"
      sha256 "0cc7f079079dcad8293fea36875ef58dd1bfd75ce1a6c244cd73ed9523eb13d4"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Date-6.02.tar.gz"
      sha256 "e8b9941da0f9f0c9c01068401a5e81341f0e3707d1c754f8e11f42a7e629e333"
    end

    resource "HTML::Headers" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.18.tar.gz"
      sha256 "d060d170d388b694c58c14f4d13ed908a2807f0e581146cef45726641d809112"
    end

    resource "LWP::ConnCache" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.20.tar.gz"
      sha256 "3cf4d1bdade592fc9dd7710403255ef2eebb075b7365cbe52fcdfc579d79b2b0"
    end

    resource "LWP::Protocol::https" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.07.tar.gz"
      sha256 "522cc946cf84a1776304a5737a54b8822ec9e79b264d0ba0722a70473dbfb9e7"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/URI-1.74.tar.gz"
      sha256 "a9c254f45f89cb1dd946b689dfe433095404532a4543bdaab0b71ce0fdcdd53d"
    end

    resource "XML-LibXML" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0132.tar.gz"
      sha256 "721452e3103ca188f5968ab06d5ba29fe8e00e49f4767790882095050312d476"
    end

    resource "XML::SAX::Exception" do
      url "https://cpan.metacpan.org/authors/id/K/KH/KHAMPTON/XML-SAX-Base-1.02.tar.gz"
      sha256 "c541861df7e70f83950afedf2058148aa9d4bd733929a869829c97833ad1600b"
    end
  end

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
    end

    bin.install "get_iplayer", "get_iplayer.cgi"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
    man1.install "get_iplayer.1"
  end

  test do
    output = shell_output("\"#{bin}/get_iplayer\" -f --refresh-include=\"BBC None\" -q dontshowanymatches 2>&1")
    assert_match "get_iplayer #{pkg_version}-homebrew", output, "Unexpected version"
    assert_match "INFO: 0 matching programmes", output, "Unexpected output"
    assert_match "INFO: Indexing tv programme schedules", output,
                         "Mojolicious not found"
  end
end
