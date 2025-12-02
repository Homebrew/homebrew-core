class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.52.tar.gz"
  sha256 "1126f3a95856d08889ff89703cb1aa9ec9924d939d154e96904c920f05dc3c74"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "ISC"]

  livecheck do
    url "https://download.pureftpd.org/pub/pure-ftpd/releases/"
    regex(/href=.*?pure-ftpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "074159e0cd8e43d95bd13eb594a71c72633f447098845594f0fb198cd84860c0"
    sha256 cellar: :any,                 arm64_sequoia: "373b7548ab16130c222ce6d0d5f572058d9861ec3131646dbebe02e49c25f45c"
    sha256 cellar: :any,                 arm64_sonoma:  "9bd6c0ac304fdd31a8add00908af3537ab6d1044d2f62845164fd77d04ae3b3e"
    sha256 cellar: :any,                 arm64_ventura: "12f524ce868de1e8cba324a2247bcba19cb13554cc2e8bf1addea3193a1b9dbe"
    sha256 cellar: :any,                 sonoma:        "0b042372d9d3d61067a8607a8dd6bbe6206344fac47bdf43c83affe0c12d4290"
    sha256 cellar: :any,                 ventura:       "6b565281bbbaa6d6f1db74766b2eb631c93620efdaffe822707e4270ee4ee2ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "318cc3007e75d2ec4361c68eaad1376ad2d50983deafeff9b9dca0a21722d97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdb09570741e1b04ee89849d62cdc4b7440b2ab283cd7d6d90724009a122e442"
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
