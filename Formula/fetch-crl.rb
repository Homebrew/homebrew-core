class FetchCrl < Formula
  desc "Retrieve certificate revocation lists (CRLs)"
  homepage "https://wiki.nikhef.nl/grid/FetchCRL3"
  url "https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.21.tar.gz"
  sha256 "19a96b95a1c22da9d812014660744c6a31aac597b53ac17128068a77c269cde8"
  license "Apache-2.0"

  livecheck do
    url "https://dist.eugridpma.info/distribution/util/fetch-crl/"
    regex(/href=.*?fetch-crl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a4c9b13b21861b5d6f591234a814e7fafcf83622aa2aefa4d11d64352538d017" => :big_sur
    sha256 "96804f5b491baeb338b76d851e8f7f3b06c509e6105abb7c9b826060c0c83980" => :arm64_big_sur
    sha256 "7c4aedc9178b36cf45d9a05ed4213c5c2ede584dc1c2754f2370b91f42a1efe3" => :catalina
    sha256 "7c4aedc9178b36cf45d9a05ed4213c5c2ede584dc1c2754f2370b91f42a1efe3" => :mojave
    sha256 "7c4aedc9178b36cf45d9a05ed4213c5c2ede584dc1c2754f2370b91f42a1efe3" => :high_sierra
  end

  resource "LWP" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.43.tar.gz"
      sha256 "e9849d7ee6fd0e89cc999e63d7612c951afd6aeea6bc721b767870d9df4ac40d"
    end
  end

  resource "HTTP::Request" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.18.tar.gz"
      sha256 "d060d170d388b694c58c14f4d13ed908a2807f0e581146cef45726641d809112"
    end
  end

  resource "URI" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-1.76.tar.gz"
      sha256 "b2c98e1d50d6f572483ee538a6f4ccc8d9185f91f0073fd8af7390898254413e"
    end
  end

  resource "HTTP::Date" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
      sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
    end
  end

  resource "Try::Tiny" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.28.tar.gz"
      sha256 "f1d166be8aa19942c4504c9111dade7aacb981bc5b3a2a5c5f6019646db8c146"
    end
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ETC=#{etc}", "CACHE=#{var}/cache"
  end

  test do
    system sbin/"fetch-crl", "-l", testpath
  end
end
