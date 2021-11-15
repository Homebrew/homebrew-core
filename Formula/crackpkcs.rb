class Crackpkcs < Formula
  desc "Multithreaded program to crack PKCS#12 files"
  homepage "https://crackpkcs12.sourceforge.io"
  url "https://download.sourceforge.net/project/crackpkcs12/0.2.11/crackpkcs12-0.2.11.tar.gz"
  sha256 "9cfd0aa1160545810404fff60234c7b6372ce7fcf9df392a7944366cae3fbf25"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "531a0ea5e420e1a5d8a33efc3f3f027bed2125c1bb00aea565bd2bdde220d677"
    sha256 cellar: :any, arm64_big_sur:  "c78cddbd0a61219de5e403a5cf43c710a5a50141ccb3c66767823f0fb8941a70"
    sha256 cellar: :any, monterey:       "cf977d20a83190062068fb6c57d631761af2f8a1cf8985de088abc61db757384"
    sha256 cellar: :any, big_sur:        "6616b50b8bdc80f28a69184fe91d3c191c39f8259f539cab29009c65a79d2a99"
    sha256 cellar: :any, catalina:       "32c0e6b6e178c8afd6cf5e98807d1f165a5fccf41d2120f57036653fef1952c7"
    sha256 cellar: :any, mojave:         "ba3ab6f7c683ebf8f4eedb1528bb88941b31a52c69c4139c16f2388ea2b504f7"
  end

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
