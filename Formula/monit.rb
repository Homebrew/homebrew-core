class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.31.0.tar.gz"
  sha256 "eae71f28941fb663eec74c1a59b69546c659529796550bd9c0c544e9b52ac055"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2f6358307e57abfb67bed43795f111e35b4c73cc3b8aa2fb55dcf4faab15a4c1"
    sha256 cellar: :any,                 arm64_big_sur:  "a1675e5bc8df5ba9fa78fbc81a343745cfb223872b5a2a1ffbfbdbbb8d911210"
    sha256 cellar: :any,                 monterey:       "583be054633b9b3f9d2c12d119e1e62987edaff1faef91e410863a463bba0477"
    sha256 cellar: :any,                 big_sur:        "3cace631abc2ab4efb7fe4728f18899a66ad2eacaae6dc9e950ba531ddc98d80"
    sha256 cellar: :any,                 catalina:       "9d64bbb0b2be8e5293fce0e6c3eb453ae593f9e212474342061a85003b049db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dfdf7ae8ddf0bc11e2612b8bc9da3acc990bb9d112b72bccf57bf984ddd1f49"
  end

  depends_on "openssl@1.1"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  service do
    run [opt_bin/"monit", "-I", "-c", etc/"monitrc"]
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end
