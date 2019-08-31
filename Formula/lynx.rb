class Lynx < Formula
  desc "Text-based web browser"
  homepage "https://invisible-island.net/lynx/"
  url "https://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.9rel.1.tar.bz2"
  version "2.8.9rel.1"
  sha256 "387f193d7792f9cfada14c60b0e5c0bff18f227d9257a39483e14fa1aaf79595"
  revision 1

  bottle do
    sha256 "61c9bfb70ad4c2b036f7c471b5e23502625b20ea835e13e42fc42743536f93e2" => :mojave
    sha256 "efd1ec304b8f8c76c840b09abc0ca564c7c393bc33e0f572ff8979086ea81a73" => :high_sierra
    sha256 "14c607d4f273ab4f6974bea3d8b2892eaaa919c48d6ea4637b5e97759c9365d1" => :sierra
    sha256 "2240132091626d4577ec75e0e24ffba4052d13534ce8bf28f766b3b255d0286d" => :el_capitan
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-echo",
                          "--enable-default-colors",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--enable-ipv6"
    system "make", "install"
  end

  test do
    system "#{bin}/lynx", "-dump", "https://example.org/"
  end
end
