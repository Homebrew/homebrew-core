class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.51.tar.gz"
  sha256 "4160f66b76615eea2397eac4ea3f0a146b7928207b79bc4cc2f99ad7b7bd9513"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "ISC"]
  revision 2

  livecheck do
    url "https://download.pureftpd.org/pub/pure-ftpd/releases/"
    regex(/href=.*?pure-ftpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3db4a9db54790a96731b2e7621e0406eb05bc066184ebd05e30ecc029207375c"
    sha256 cellar: :any,                 arm64_ventura:  "a7fc20279fa1b5f56cb04279c6acdec39ea86bde3bf214cf915685b611010361"
    sha256 cellar: :any,                 arm64_monterey: "cbecdae9932dfc6c3ac346665391820e90bc8acf18d28bc4efb8ea7c27d2c9bb"
    sha256 cellar: :any,                 sonoma:         "443984b6215f2d30b153ff04f640618cd9ec634955be95761b697d2a02321199"
    sha256 cellar: :any,                 ventura:        "189c84eb6bafec8086a55b8a7822a84cc329533371dd99695a4202621ac1657f"
    sha256 cellar: :any,                 monterey:       "44e712432e352ccec44837fcc2e47bd792941138faa817ab7b547a78ae105299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f34a618c6f5f5c663820dcda67629b086e638f92f01e3643d373f6198a8742"
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
