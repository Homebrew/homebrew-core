class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.35.0.tar.gz"
  sha256 "9760c3aa28611fc1438666540ace00d572a4f29742a3a546d65628744af5f474"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3d2dd90fe2254f556d1bd0bbd77f3a639502e0a3d703d6daea0fc4c231f9b209"
    sha256 cellar: :any,                 arm64_sonoma:  "3b731aedc75119f6400dd4ea3614882889c89ec366057e48df42cc9be7299894"
    sha256 cellar: :any,                 arm64_ventura: "07f523a432a4674800daad82e1ef74dcd88bbd41b5203bf001a425aa1f37f9d8"
    sha256 cellar: :any,                 sonoma:        "02688be7e8d9e8f9925a0e73da75776c36440dbb677ff7163a011ba0441343cb"
    sha256 cellar: :any,                 ventura:       "bc55c8ef9541345e5c9238636647b8426e58762bea7591ff862d9932cfa94706"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63c07eb908c94f039f25b69a3f3498cf2b5784d12b5afddebff9714f9cb8602e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d648b1eb7d9e773c71dbfd14d414be27276225c8cbc1c2f9a58db52e7cdbb457"
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
