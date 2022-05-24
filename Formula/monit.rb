class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.32.0.tar.gz"
  sha256 "1077052d4c4e848ac47d14f9b37754d46419aecbe8c9a07e1f869c914faf3216"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "daa3ed9e9e1a2fe150082565d8d98f88f22d9812fcfe106e03fa7044e6b9ee62"
    sha256 cellar: :any,                 arm64_big_sur:  "7f7cbfd474af9c46ed2d3bf33d7d33439d26f2346fa0f24fc32a00bc9557c92f"
    sha256 cellar: :any,                 monterey:       "e9c9b1d3fcbdd3aebb24bab99370239a6b3c8c455dc6693883ceafe50fca011d"
    sha256 cellar: :any,                 big_sur:        "50715f7eab06cfdfd51030b020b62aa7409e0cad8ece6e176804adf536e34d69"
    sha256 cellar: :any,                 catalina:       "46170c651cc00edb1916a89bf4943131cf7662db499fef5337c8744f5f641711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db93e068d4d6bf3525b3d6a8993dfd0ddccc82b154921fab3ca0be0522ce885d"
  end

  depends_on "openssl@1.1"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}"
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
