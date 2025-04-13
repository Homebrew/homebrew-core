class Crackpkcs < Formula
  desc "Multithreaded program to crack PKCS#12 files"
  homepage "https://crackpkcs12.sourceforge.net/"
  url "https://download.sourceforge.net/project/crackpkcs12/0.2.11/crackpkcs12-0.2.11.tar.gz"
  sha256 "9cfd0aa1160545810404fff60234c7b6372ce7fcf9df392a7944366cae3fbf25"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0b89c0ab5d87df237985c9b1c638457eda5e1fb3d3ce2beda99c4b8ee7f0d1b0"
    sha256 cellar: :any,                 arm64_ventura:  "941c264ba6fed6fb691c2bae290d4a47bf68b62d8fbbbf3cd3f5767ad6b437c7"
    sha256 cellar: :any,                 arm64_monterey: "531a0ea5e420e1a5d8a33efc3f3f027bed2125c1bb00aea565bd2bdde220d677"
    sha256 cellar: :any,                 arm64_big_sur:  "c78cddbd0a61219de5e403a5cf43c710a5a50141ccb3c66767823f0fb8941a70"
    sha256 cellar: :any,                 sonoma:         "6ac6965acf31cbce243630ac232c61e3b23d14325d4445a8b89a85e3e5a0fe1c"
    sha256 cellar: :any,                 ventura:        "8042cedd03a5382d67488238ddcce502b6a38cc2a3f2e101f9f8ad819051d4d8"
    sha256 cellar: :any,                 monterey:       "cf977d20a83190062068fb6c57d631761af2f8a1cf8985de088abc61db757384"
    sha256 cellar: :any,                 big_sur:        "6616b50b8bdc80f28a69184fe91d3c191c39f8259f539cab29009c65a79d2a99"
    sha256 cellar: :any,                 catalina:       "32c0e6b6e178c8afd6cf5e98807d1f165a5fccf41d2120f57036653fef1952c7"
    sha256 cellar: :any,                 mojave:         "ba3ab6f7c683ebf8f4eedb1528bb88941b31a52c69c4139c16f2388ea2b504f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fe6ba851498a7e734d172a966411bf9d2afed85ba6bd6c85cb3bac2f2d865af"
  end

  # Match deprecation date of `openssl@1.1` as current release segfaults with `openssl@3`.
  # Last release on 2018-03-10.
  disable! date: "2024-08-01", because: :unmaintained

  depends_on "pkgconf" => :build
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
