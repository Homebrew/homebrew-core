class FetchCrl < Formula
  desc "Retrieve certificate revocation lists (CRLs)"
  homepage "https://wiki.nikhef.nl/grid/FetchCRL3"
  url "https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.22.tar.gz"
  sha256 "09bcf5d1004ac8c3ced5e71b70e6b6afb7f713630aca0afbfa2db3244567cb2b"
  license "Apache-2.0"

  livecheck do
    url "https://dist.eugridpma.info/distribution/util/fetch-crl/"
    regex(/href=.*?fetch-crl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31195e7618b568140819ca5220581f5fee24d18049a925116e144aff0e07410c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31195e7618b568140819ca5220581f5fee24d18049a925116e144aff0e07410c"
    sha256 cellar: :any_skip_relocation, monterey:       "31195e7618b568140819ca5220581f5fee24d18049a925116e144aff0e07410c"
    sha256 cellar: :any_skip_relocation, big_sur:        "31195e7618b568140819ca5220581f5fee24d18049a925116e144aff0e07410c"
    sha256 cellar: :any_skip_relocation, catalina:       "31195e7618b568140819ca5220581f5fee24d18049a925116e144aff0e07410c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c479b15b49f159bd6371fe3e609024bf716caf93561861e4e6c0aaca296755fd"
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
