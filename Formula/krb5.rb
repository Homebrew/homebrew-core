class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.18/krb5-1.18.2.tar.gz"
  sha256 "c6e4c9ec1a98141c3f5d66ddf1a135549050c9fab4e9a4620ee9b22085873ae0"

  bottle do
    sha256 "d8699796a22fade66339df1ba28b4faf10caeb1772d79601e6352665bb433dac" => :catalina
    sha256 "0171567eb1400f14a4cf9a62b637b79587e4b6fcbeb8ee9c7700da5a9bade2c3" => :mojave
    sha256 "3e33314ea8b15664bcd985d3b8daa91e3021ebcaa69937d370148f00c82127c7" => :high_sierra
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  uses_from_macos "bison"

  def install
    cd "src" do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}",
                            "--without-system-verto"
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
