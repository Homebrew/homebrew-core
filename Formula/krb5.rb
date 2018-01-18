class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.16/krb5-1.16.tar.gz"
  sha256 "faeb125f83b0fb4cdb2f99f088140631bb47d975982de0956d18c85842969e08"

  bottle do
    sha256 "c31f35f264498fbf82bfb940e6c671e53ca1acf9db338ff6bfbc11c43e790a19" => :high_sierra
    sha256 "dbf24c411aa982dcc5c1496ee026205f8fb5f6e51531490e1d7f4aafd14a3473" => :sierra
    sha256 "542388bcad53bf98142ed2803ab1054be4e2bbb89920a883f504fdd254db5fae" => :el_capitan
  end

  keg_only :provided_by_macos

  depends_on "openssl"

  def install
    cd "src" do
      system "./configure",
        "--disable-debug",
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
