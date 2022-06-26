class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.51.tar.gz"
  sha256 "4160f66b76615eea2397eac4ea3f0a146b7928207b79bc4cc2f99ad7b7bd9513"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "ISC"]

  livecheck do
    url "https://download.pureftpd.org/pub/pure-ftpd/releases/"
    regex(/href=.*?pure-ftpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "04a014a07b5724eddde7e97b635763e9ea6fdf59fc1db3702c52d5c531b853c3"
    sha256 cellar: :any,                 arm64_big_sur:  "c595fedada8a973348008154b83aa191e68f8d00fec03dd4e223e7abd6c2a701"
    sha256 cellar: :any,                 monterey:       "a99b679ff53adc1e2b7843e43c33bc8d68443cb25fef918bdc5375fdf20e0463"
    sha256 cellar: :any,                 big_sur:        "9be7e45889d49eb3de97419c6167d6fbb6a49feb774267c704723837b8f7239b"
    sha256 cellar: :any,                 catalina:       "3ddd85304ce30f15b78eac175630ba6e7420d7f3fddd193eeee468e6d3e02012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3607e2c5a94310cbcf4da7e357bd69464b7380bd8513073db7c865cff0f4a3e9"
  end

  depends_on "libsodium"
  depends_on "openssl@1.1"

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
