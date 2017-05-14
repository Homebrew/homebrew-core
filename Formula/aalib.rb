class Aalib < Formula
  desc "Portable ASCII art graphics library"
  homepage "https://aa-project.sourceforge.io/aalib/"
  url "https://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz"
  sha256 "fbddda9230cf6ee2a4f5706b4b11e2190ae45f5eda1f0409dc4f99b35e0a70ee"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c3bb440617a66459f7baf954342801c575488e9312fde720b6b7bd5476ed9abe" => :sierra
    sha256 "06bd52bb36bc45e839cc6581baa11580d8ab786f83fd878e725d1b0923497c7b" => :el_capitan
    sha256 "f018850bc3f7cb622b5fd19a1b9910f5be3218b70cbf36e158f0f241ddff05ec" => :yosemite
    sha256 "45922d8c9e423b8249bfee4263d9b7c848eec19e72f553ce9271eb60795ae6ff" => :mavericks
    sha256 "b2fd6584ff2ad3afc0050e0663ad680f84c79d59958afb043681bac77e9fd2fc" => :mountain_lion
  end

  # Fix malloc/stdlib issue on macOS
  # Fix underquoted definition of AM_PATH_AALIB in aalib.m4
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6e23dfb/aalib/1.4rc5.patch"
    sha256 "54aeff2adaea53902afc2660afb9534675b3ea522c767cbc24a5281080457b2c"
  end

  def install
    ENV.ncurses_define
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-shared=yes",
                          "--enable-static=yes",
                          "--without-x"
    system "make", "install"
  end

  test do
    system "script", "-q", "/dev/null", bin/"aainfo"
  end
end
