class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.15.1.tar.gz"
  sha256 "2713d8719be53db7a529cbf53064e5bc9f3adf009db339d3a81b50d471bc306f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "03bed35243ebc9f4579cd1a7caf64400ce3d9123176d7b1b7ecf6f04e42292ac" => :catalina
    sha256 "cfb9de18466a896b671cc5fafdd7549297ae32887733142fe7c3d99e748399c9" => :mojave
    sha256 "aa57810f89ab4518d9e730fffbc885e46e1c8cede7b6877b066e001b14917fe0" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on :macos # Due to Python 2
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
