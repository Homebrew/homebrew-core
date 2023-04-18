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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "fe468fefa19fc750c5051d20d4c6d9a92652a5092aae7fa04eb8f7b5420216c3"
    sha256 cellar: :any,                 arm64_monterey: "5e9abb79554e46ed02c642d430202db07368e5c7ac8148abf78bc8b3cc315d6c"
    sha256 cellar: :any,                 arm64_big_sur:  "34c0a150261bce1eef864d73033e583efefa5829d5301723f2acd7f839c1c5ce"
    sha256 cellar: :any,                 ventura:        "995f0f60518511f25a75d4bc3c03bb538ef5d1471ef8ab5d54796fc0747865cb"
    sha256 cellar: :any,                 monterey:       "46c89155e8910f6b8c9f6834f31d383c7d6fdf5c72ff6dc64474a9c57f1e9907"
    sha256 cellar: :any,                 big_sur:        "3af1b813b093423c66ab1d7c5d5ef192562d6eeb0754ad0ce68f05afa17dd091"
    sha256 cellar: :any,                 catalina:       "5083006d58cd0f7e6824e95998c299cb7d090fc2d049b8e797ddf0b27ac90207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1800a3342d761db7a85e0d482f52c0b689835713dd15a5bba90a617a43160151"
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
