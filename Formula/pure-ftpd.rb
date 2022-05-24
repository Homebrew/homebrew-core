class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.50.tar.gz"
  sha256 "abe2f94eb40b330d4dc22b159991f44e5e515212f8e887049dccdef266d0ea23"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "ISC"]

  livecheck do
    url "https://download.pureftpd.org/pub/pure-ftpd/releases/"
    regex(/href=.*?pure-ftpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "37b7a18770c4050e170e73e9f91b0c4e89796b27b4bc97383f4c01e5d1b845c2"
    sha256 cellar: :any,                 arm64_big_sur:  "be2354790a43f2530fade9684e49afdf6127e720e8a1a3396b284aa21e230a48"
    sha256 cellar: :any,                 monterey:       "31ec7d058a66adc3e31d5b550e9dffa8d9d4388d125e25a701ac46e6b4f1480a"
    sha256 cellar: :any,                 big_sur:        "f8a22572ca75768fa21b1177c77f8f222429726dbc21b8cd9fa061ddb3ecaaaf"
    sha256 cellar: :any,                 catalina:       "a3cfa341bc66691b8f5962d493799c5f2f2c68114cc7a101493728991f18b423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97e9bebb7b6f9e9348e1151637f7d1ad046550426cc0b2e80186cd06205ad93d"
  end

  depends_on "libsodium"
  depends_on "openssl@1.1"

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
