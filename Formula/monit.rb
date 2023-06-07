class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.33.0.tar.gz"
  sha256 "1ace889c0183473a9d70160df6533bb6e1338dc1354f5928507803e1e2a863b5"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f1024bae43bfcca2a3ee00b7187697e5a77a50e23463002c36e82f7132658ba0"
    sha256 cellar: :any,                 arm64_monterey: "7c7a32d75f6734a2b2a61cac1d0e59b0ad1c3d71620a54224065ac4014f85a12"
    sha256 cellar: :any,                 arm64_big_sur:  "5d74012f14f185b8629a51a39806c14812c4263b006cb5d0ed9c94d072c5e176"
    sha256 cellar: :any,                 ventura:        "48f72f14abe8dcf2ddb1098941cd95dc93d12f0edc9f0dca5e14db4ff7f87a43"
    sha256 cellar: :any,                 monterey:       "90e39aed578138b6aaeb76543ad4cece92eb6dac1df97a76477d1937e55f4515"
    sha256 cellar: :any,                 big_sur:        "84f5b178be718b9b352a8dcff77050eddfd5ae91b19f995fbd845e785fdab8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a446fd373c8ede9475f583ce8f491cf4b122b7519ca4fb87189af7be3dec345"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@3"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  service do
    run [opt_bin/"monit", "-I", "-c", etc/"monitrc"]
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end
