class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.54.tar.gz"
  sha256 "dc9140420ec44f7829579591ff378aa6396b4604b9c6aeae847368e0f35bd7b2"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "ISC"]
  revision 1

  livecheck do
    url "https://download.pureftpd.org/pub/pure-ftpd/releases/"
    regex(/href=.*?pure-ftpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d56b653caa9fe8125947e025d3ddcacb9e1aec9855de22386e5a15923d0aef7a"
    sha256 cellar: :any, arm64_tahoe:       "b66cf2bb6d7f300cfcd30e70e90cfc1cc9678bf82487468d69f2939d1a8b3eb8"
    sha256 cellar: :any, arm64_sequoia:     "b24971fd167c7d137d2082ddfa81837756fd003eadf42dd8224eb406dd95edaa"
    sha256 cellar: :any, arm64_linux:       "fb23303d3c562b72d2548eda08c620bd13c623e80a7915b82d2e5966cd21daba"
    sha256 cellar: :any, x86_64_linux:      "8673aa329400ce8d62e19bd026baf9309568c58e660c1b90eb9e1d49c63bccb3"
  end

  depends_on "libsodium"
  depends_on "openssl@4"

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
