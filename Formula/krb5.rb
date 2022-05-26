class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.20/krb5-1.20.tar.gz"
  sha256 "7e022bdd3c851830173f9faaa006a230a0e0fdad4c953e85bff4bf0da036e12f"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_monterey: "7f30cce97c416b93645c3b253b645918c03198723d021455396fe36baafd4a2f"
    sha256 arm64_big_sur:  "22079afd89def4206cd1fcd5d6ae2b9b1f993104ddee5e954b9e664a42467d6c"
    sha256 monterey:       "8d46fa7a28cdb0090702246c7a3053f3a8aca434300e2ac78b6482cb6a2f9d57"
    sha256 big_sur:        "3005212aa78341c000995454977553b1ea7cfacd11bd04e24feace7e829a7d02"
    sha256 catalina:       "e269d5d0c19c6da2521b8ab8a51f5ac1229387b4ff17eea4df216d1e0031784f"
    sha256 x86_64_linux:   "ddc056655dfc8c6b880729096c25968b52cb39de533c61053c0c74a69961bce6"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  uses_from_macos "bison"

  on_linux do
    depends_on "gettext"
  end

  def install
    cd "src" do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}",
                            "--without-system-verto",
                            "--without-keyutils"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
