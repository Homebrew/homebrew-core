class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.35.2.tar.gz"
  sha256 "4dfef54329e63d9772a9e1c36ac99bc41173b79963dc0d8235f2c32f4b9e078f"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "23d94b8e82a4021c0cb4a192ddc4b47f7a1dd8c96551334086ec69d90b56a1f0"
    sha256 cellar: :any,                 arm64_sequoia: "5f8ae5d9b7905575c6a521cd10ec05c2b8c44c83ca7525a045404196a1b6d0b6"
    sha256 cellar: :any,                 arm64_sonoma:  "fc482b423f6a54a5fd3d654ec2047d6f57390fc54778317021ab1ec319a72f5c"
    sha256 cellar: :any,                 arm64_ventura: "725215581b9ee73ed26819ae29282310bbc1d737285325c54af1bd3523af6837"
    sha256 cellar: :any,                 sonoma:        "0330014e721c9cbff3b5f610bf9b328fe23c5788ccab3a728d89ac9dad79eb52"
    sha256 cellar: :any,                 ventura:       "c18bf4f5bf096b868c6b5016c50e065870305a9477bab6bd3c7635790de7c61a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "785a1c67205c69e345698ba258e55247e3b5c147a0910d02ab27fe3638c00630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24a6151e67eca2312abdba53b643dd791ef72ad31e9c376190e96aef37f1e8c6"
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
