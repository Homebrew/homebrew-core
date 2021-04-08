class Crackpkcs < Formula
  desc "Multithreaded program to crack PKCS#12 files"
  homepage "https://crackpkcs12.sourceforge.io"
  url "https://download.sourceforge.net/project/crackpkcs12/0.2.11/crackpkcs12-0.2.11.tar.gz"
  sha256 "9cfd0aa1160545810404fff60234c7b6372ce7fcf9df392a7944366cae3fbf25"
  license "GPL-3.0-or-later"

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  resource "cert.p12" do
    url "https://github.com/crackpkcs12/crackpkcs12/raw/9f7375fdc7358451add8b31aaf928ecd025d63d9/misc/utils/certs/usr0052-exportado_desde_firefox.p12"
    sha256 "8789861fbaf1a0fc6299756297fe646692a7b43e06c2be89a382b3dceb93f454"
  end

  def install
    system "./configure",
            *std_configure_args,
            "--disable-silent-rules",
            "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    resource("cert.p12").stage do
      output = shell_output("#{bin}/crackpkcs12  -m 7 -M 7 -s usr0052 -b usr0052-exportado_desde_firefox.p12")
      assert_match "Brute force attack - Thread 1 - Password found: usr0052", output
    end
  end
end
