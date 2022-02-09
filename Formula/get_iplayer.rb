class GetIplayer < Formula
  desc "Utility for downloading TV and radio programmes from BBC iPlayer"
  homepage "https://github.com/get-iplayer/get_iplayer"
  url "https://github.com/get-iplayer/get_iplayer/archive/v3.29.tar.gz"
  sha256 "621ef2e13cfa1d6ba68a5d1b877b585fea85c321916cc50d44301e239cf3d606"
  license "GPL-3.0-or-later"
  head "https://github.com/get-iplayer/get_iplayer.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50231486cb26902f453bff6ae7067252a20bf7850840bc6c4c81fdbb36e8d09d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3e58b4b1491012fe9b47957ae21371a48ef4461607d96244ed7696eadd00369"
    sha256 cellar: :any_skip_relocation, monterey:       "56249b5f3a1b47e5edab99c7f69175a5b77324cd1bd0c52f8ebe3501efa03c6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2f2726f5a5fde4106db198c1e06c8fe4cf2e37479b6087846161bdb36f7f348"
    sha256 cellar: :any_skip_relocation, catalina:       "761c96b0ee05c317f493aa69e4e5ffc6120a98e9bd0884d4aa25c71b9fe051d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "799320a0eb9009c7acd773b9dfd6c4edbb84ff668396f82ee43a3d8d9c6be60f"
  end

  depends_on "atomicparsley"
  depends_on "ffmpeg"

  uses_from_macos "libxml2"
  uses_from_macos "perl"

  on_linux do
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
    assert_match "INFO: Indexing tv programmes (concurrent)", output,
                         "Mojolicious not found"
  end
end
