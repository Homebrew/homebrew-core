class FetchCrl < Formula
  desc "Retrieve certificate revocation lists (CRLs)"
  homepage "https://wiki.nikhef.nl/grid/FetchCRL3"
  url "https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.24.tar.gz"
  sha256 "6a109c3cd93531e5fbd9e3fc4cef5cdda4a553c31e983507cead72a145627fa7"
  license "Apache-2.0"

  livecheck do
    url "https://dist.eugridpma.info/distribution/util/fetch-crl/"
    regex(/href=.*?fetch-crl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dd6f07a8c4f8a431947dc62fb4227d2533b8b8109e5846a40ff0921cd7ab279"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dd6f07a8c4f8a431947dc62fb4227d2533b8b8109e5846a40ff0921cd7ab279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dd6f07a8c4f8a431947dc62fb4227d2533b8b8109e5846a40ff0921cd7ab279"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1e966c1cc59d653cc3873e176c93e166d6c1024b039975617bf67b5f23452ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe090b6633c495b997db7697b0576524d9b283b2d036dc62cb4ff494afd20dd5"
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
    end
  end

  test do
    system bin/"fetch-crl", "-l", testpath
  end
end
