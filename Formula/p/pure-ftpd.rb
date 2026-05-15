class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.54.tar.gz"
  sha256 "dc9140420ec44f7829579591ff378aa6396b4604b9c6aeae847368e0f35bd7b2"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "ISC"]

  livecheck do
    url "https://download.pureftpd.org/pub/pure-ftpd/releases/"
    regex(/href=.*?pure-ftpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cf1841b3487dbdb3a5e380f3b178c354de508df29650fcf6086ed95db8b54690"
    sha256 cellar: :any,                 arm64_sequoia: "2cba9ea69e0371fa58f81a9050098367e4f4cf17b05dd4affde15b0cb4432ce1"
    sha256 cellar: :any,                 arm64_sonoma:  "934d776804d04642e781ce5af6f7e188d1056cfcfd2e339baf3ac57dff63140a"
    sha256 cellar: :any,                 sonoma:        "482b64b01f30ab8f2a4dddc3be252d6bb18d6550bf8ca31aaab9866c9aa37aa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fb3186c3cda4f475ad070daaeb5beb75180d8ebc49eb216a4d4603b23b10b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b6a2c4c3332e1004565d84826972a9ad032b01f0ec50438dd5b94a4c7729fb3"
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
