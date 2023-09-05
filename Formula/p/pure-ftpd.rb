class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.51.tar.gz"
  sha256 "4160f66b76615eea2397eac4ea3f0a146b7928207b79bc4cc2f99ad7b7bd9513"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "ISC"]
  revision 1

  livecheck do
    url "https://download.pureftpd.org/pub/pure-ftpd/releases/"
    regex(/href=.*?pure-ftpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a6f41d0fbf23150cdab22ddd9afbdeebb099f4e53537182d9980f06f9b26dbac"
    sha256 cellar: :any,                 arm64_monterey: "1b67abcc9edd60aead2142a140209ae6697e4e229785d86de09c596c31488bff"
    sha256 cellar: :any,                 arm64_big_sur:  "3bc73b3496165c30c7ab46f68794336afd1da8979a9213d7e4a05d536b7e60a9"
    sha256 cellar: :any,                 ventura:        "544c26284f46449f9ccdf4a2ae18e9906c83a5387e9e6c7ef86a35e909ce8c97"
    sha256 cellar: :any,                 monterey:       "a528d655c319b209b6b5791ec9f29730f45dd84d0cee608cab3be611b17f210a"
    sha256 cellar: :any,                 big_sur:        "1e5868c9218be8b930ef9f32992ef3f87c180faf03acb58387429b99a6b79e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "633b0bb81436b00c8701ce9db2c560a7b43a8277b0482cc66c26ff9dbb4350ec"
  end

  depends_on "libsodium"
  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-everything
      --with-pam
      --with-tls
      --with-bonjour
    ]

    system "./configure", *args
    system "make", "install"
  end

  service do
    run [opt_sbin/"pure-ftpd", "--chrooteveryone", "--createhomedir", "--allowdotfiles",
         "--login=puredb:#{etc}/pureftpd.pdb"]
    keep_alive true
    working_dir var
    log_path var/"log/pure-ftpd.log"
    error_log_path var/"log/pure-ftpd.log"
  end

  test do
    system bin/"pure-pw", "--help"
  end
end
