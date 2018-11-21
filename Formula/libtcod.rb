class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "http://roguecentral.org/doryen/libtcod/"
  url "https://bitbucket.org/libtcod/libtcod/get/1.8.2.tar.bz2"
  sha256 "a33aa463e78b6df327d2aceae875edad8dba7a9e5ea0f1299c486b99f4bed31c"

  bottle do
    cellar :any
    sha256 "d32d2e923b6dec98fc17d75b4abc59080ad831e7b17c9e4e973bd22652205ac6" => :mojave
    sha256 "c9e64cf1266592a440401c31028f97daf076d8bb9ace113a19da1b9c6a01b4bc" => :high_sierra
    sha256 "360839e84034f149f3538be489273274a7db2f3b9020162dc94b9798e31dc402" => :sierra
    sha256 "8728af3c1c018e2586708b66fdf8578260a83c875602ff6e796f96f44ea0382e" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  conflicts_with "libzip", :because => "both install `zip.h` header"

  def install
    cd "build/autotools" do
      system "autoreconf", "-fiv"
      system "./configure"
      system "make"
      lib.install Dir[".libs/*{.a,.dylib}"]
    end
    include.install Dir["include/*"]
    # don't yet know what this is for
    libexec.install "data"
  end
end
