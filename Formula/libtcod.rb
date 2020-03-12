class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.15.1.tar.gz"
  sha256 "2713d8719be53db7a529cbf53064e5bc9f3adf009db339d3a81b50d471bc306f"

  bottle do
    cellar :any
    sha256 "48c1dc06ec54ec78c8f4cda6c7fd15792cf4a2ae6c9b65f015cc243c9cb47649" => :catalina
    sha256 "29c26abf54281335e0b06960fb8a9c1f99c86f9f1e0a95ef323e3767ecd44898" => :mojave
    sha256 "8b92b6d780acbdf957141cc30f76f967949bd15519b060a163133a55888c20f1" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "sdl2"

  conflicts_with "libzip", "minizip2",
    :because => "libtcod, libzip and minizip2 install a `zip.h` header"

  def install
    cd "buildsys/autotools" do
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
