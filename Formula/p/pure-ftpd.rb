class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.53.tar.gz"
  sha256 "b3f2b0194223b1e88bf8b0df9e91ffb5d1b9812356e9dd465f2f97b72b21265f"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "ISC"]

  livecheck do
    url "https://download.pureftpd.org/pub/pure-ftpd/releases/"
    regex(/href=.*?pure-ftpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03cfef54d53503a02151f0fa412d98d81e1aabc3467338279bd85d058dd41415"
    sha256 cellar: :any,                 arm64_sequoia: "2b8251dbfc4608c839b7605809ea418d4d1cac9b4ffb3f6a4641c282d14c1d1f"
    sha256 cellar: :any,                 arm64_sonoma:  "a3758a3a8e337de890de59cf10f3f0c45e8c35f9dc396dffc860acdfe502b7db"
    sha256 cellar: :any,                 sonoma:        "d8f87d56821a23a8c1c8c81b0c4ff5f68670b710500964603194102161f901d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8588b13b6b674e8d0b73ada5692c1af5fe752a4c27439be3f6f324bcbef6cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24c58c62b5c4ec5c7ace78c73ef9859b65f53ab3dfd15eeaf58d7ac7e52f51bc"
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
