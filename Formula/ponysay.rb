class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "http://erkin.co/ponysay/"
  url "https://github.com/erkin/ponysay/archive/3.0.3.tar.gz"
  sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "04f9f091d3d6754a23ec95b081830c827e9394a78f1726c2a468e0cb2cc30ea0" => :high_sierra
    sha256 "e8f74a63ec7d41b958ffb230c767a4b6d0df8e6904ea7c833d0e92db22bc6835" => :sierra
    sha256 "78b6b7093f83b3f51422ef4ce3c3b3a7477a2c45584e446843ad6c37de877f27" => :el_capitan
  end

  depends_on "python3"
  depends_on "coreutils"

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
