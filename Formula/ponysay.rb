class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "http://erkin.co/ponysay/"
  url "https://github.com/erkin/ponysay/archive/3.0.3.tar.gz"
  sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f435c7af144552e093059ddc7ac841a086a2c6408289c297aafef6e7fe4b6cdc" => :high_sierra
    sha256 "faf06b8ea2cd665f51842aaf68c9d87571b6b57800ac00026ebc397297e7e519" => :sierra
    sha256 "92472e5c183a6614808951c0f9d4cc3200edc37b410b4dea28f150e4f178ea11" => :el_capitan
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
