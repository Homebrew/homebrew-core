class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "https://github.com/erkin/ponysay/"
  url "https://github.com/erkin/ponysay/archive/3.0.3.tar.gz"
  sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "356bbadfe629d492f5966462874a3535d63d568393c5917bc32795fc80864974" => :catalina
    sha256 "9aaf7cdbe355ecc5f41ed2ab753ef18b848a36a5e475b9bda38e4551af886203" => :mojave
    sha256 "481d6431bc586203d237787eaceafc116d9eccbf8d11489e1197a6eb0e034710" => :high_sierra
    sha256 "e51c96a3bf6997b73150b75eb758eb8359ca89a27a5b171b50eba3628192a31c" => :sierra
    sha256 "594b78b627cad84edef6de6dba32879cf5547215b33e7946bb3ee44c73e49214" => :el_capitan
  end

  depends_on "coreutils"
  depends_on "python"

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "install"
  end

  test do
    system "#{bin}/ponysay", "-A"
  end
end
