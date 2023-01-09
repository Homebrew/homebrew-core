class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.20/krb5-1.20.1.tar.gz"
  sha256 "704aed49b19eb5a7178b34b2873620ec299db08752d6a8574f95d41879ab8851"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_ventura:  "671c6257abcf1a03022ef9a8d7a1338abd7d2ecdad39fd918370af865595ed69"
    sha256 arm64_monterey: "a6ef38ba592b8b2b541db10011c301006c25f94b1db786b0a8f7c904755a3e1e"
    sha256 arm64_big_sur:  "000cda91ae0da2d286b8329765eaeb3da555e93a33990a0df1901c9b14891a5f"
    sha256 ventura:        "273a7b14a23c96a18cb1a59549d0446502ee979f90de438185c970c9ecfb2d01"
    sha256 monterey:       "c529cf22c6e2191065a6c60c35875f83de8247cd4fbad5c84d0c9ed40d806a3f"
    sha256 big_sur:        "5f825fc34ad2db50f2acdb6c770035bbde7b2de486eb67659ced48e0644f9cec"
    sha256 catalina:       "2c050f2444b887f5da029ee28a9add072729906bce035632ffd15f886de86ce4"
    sha256 x86_64_linux:   "e3ea64db62d46cd9ecdb3f869254c53970440dea6b959e4f62f9bd8ffe8d8e35"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  def install
    cd "src" do
      system "./configure", *std_configure_args,
                            "--disable-nls",
                            "--disable-silent-rules",
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
