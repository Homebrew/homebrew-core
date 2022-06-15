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
    sha256 cellar: :any,                 arm64_monterey: "725a66e07d4cdcb0d40d6756ee927621418911de45cc7dffab9db49b4c951415"
    sha256 cellar: :any,                 arm64_big_sur:  "4901a5e7be71246df23c10bb3eff6d83d21e445789edb852fda8ca28dae8bbbd"
    sha256 cellar: :any,                 monterey:       "6cf1a100cc6f9367348d677503f39ab6fbe0a509aa9222ec508b8d0ce76b13bb"
    sha256 cellar: :any,                 big_sur:        "5ec00e1d9c1e9211302552233704c2042ed7aba6c5ec6248f3c013bc403aa7ac"
    sha256 cellar: :any,                 catalina:       "bcddefb185e37c764fa41545b0240bb1edeeb9ef0811dc5a29dfd003e00cc868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a928d51d7db2eb97b52fade5e588d0b5c0374e1e1cfe5183eaae8795f187cb"
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
