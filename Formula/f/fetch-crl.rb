class FetchCrl < Formula
  desc "Retrieve certificate revocation lists (CRLs)"
  homepage "https://wiki.nikhef.nl/grid/FetchCRL3"
  url "https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.23.tar.gz"
  sha256 "077097aee513ac8e892bde196744c49502ee8c88c8d94740db1a3153d20d3ceb"
  license "Apache-2.0"

  livecheck do
    url "https://dist.eugridpma.info/distribution/util/fetch-crl/"
    regex(/href=.*?fetch-crl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9d7e1263bc12cd3fe2919e2179c5e53e0f11ed1d38d45e08d612ec870fca65c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "52ab61a76d3a769a87f1f61f0d4c22ff747180d99afb62ad4e91a0a1d8b957af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7677617f4cba5505e09c4ba9200801b8633cf95a56f6c242ce137ae217a5c967"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cefc451865fffbb827a6c2cb4603960bd672a69dca19b512811912bbb6cdc83a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cefc451865fffbb827a6c2cb4603960bd672a69dca19b512811912bbb6cdc83a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cefc451865fffbb827a6c2cb4603960bd672a69dca19b512811912bbb6cdc83a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7677617f4cba5505e09c4ba9200801b8633cf95a56f6c242ce137ae217a5c967"
    sha256 cellar: :any_skip_relocation, ventura:        "cefc451865fffbb827a6c2cb4603960bd672a69dca19b512811912bbb6cdc83a"
    sha256 cellar: :any_skip_relocation, monterey:       "cefc451865fffbb827a6c2cb4603960bd672a69dca19b512811912bbb6cdc83a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cefc451865fffbb827a6c2cb4603960bd672a69dca19b512811912bbb6cdc83a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7a73a914498af4f926cba98dd81c1fce335d36ca25ed0561650ff5a28ab4ab14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad140d4dcb26765b4ab846846e7a2a0a2cd422405a123d1ad0b11c02f38193da"
  end

  uses_from_macos "perl"

  on_linux do
    resource "LWP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.43.tar.gz"
      sha256 "e9849d7ee6fd0e89cc999e63d7612c951afd6aeea6bc721b767870d9df4ac40d"
    end

    resource "HTTP::Request" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.18.tar.gz"
      sha256 "d060d170d388b694c58c14f4d13ed908a2807f0e581146cef45726641d809112"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-1.76.tar.gz"
      sha256 "b2c98e1d50d6f572483ee538a6f4ccc8d9185f91f0073fd8af7390898254413e"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
      sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.28.tar.gz"
      sha256 "f1d166be8aa19942c4504c9111dade7aacb981bc5b3a2a5c5f6019646db8c146"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make"
          system "make", "install"
        end
      end
    end

    system "make", "install", "PREFIX=#{prefix}", "ETC=#{etc}", "CACHE=#{var}/cache"

    if OS.linux?
      bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"]
      sbin.env_script_all_files libexec/"sbin", PERL5LIB: ENV["PERL5LIB"]
    end
  end

  test do
    system sbin/"fetch-crl", "-l", testpath
  end
end
