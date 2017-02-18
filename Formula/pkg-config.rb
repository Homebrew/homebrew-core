class PkgConfig < Formula
  desc "Manage compile and link flags for libraries"
  homepage "https://freedesktop.org/wiki/Software/pkg-config/"
  url "https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.1.tar.gz"
  mirror "https://fossies.org/linux/misc/pkg-config-0.29.1.tar.gz"
  sha256 "beb43c9e064555469bd4390dcfd8030b1536e0aa103f08d7abf7ae8cac0cb001"
  revision 2

  bottle do
    sha256 "aa5f169cffe4576a6a6b0e3d528ab2ee0ac331ff3fe51bfbb182fb4ef7cdb794" => :sierra
    sha256 "6c89838a29bea6a641b611e631de3765b7755d987029de34419e04d85191d8a5" => :el_capitan
    sha256 "fc68806653ba68fe742885cc050990433125588099d2ea30139d1663d3d4311a" => :yosemite
  end

  def install
    mkdir_p lib/"pkgconfig"
    cp Dir["#{HOMEBREW_LIBRARY}/Homebrew/os/mac/pkgconfig/#{MacOS.version}/*"], lib/"pkgconfig"
    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
      /usr/local/lib/pkgconfig
      /usr/lib/pkgconfig
      #{lib}/pkgconfig
    ].uniq.join(File::PATH_SEPARATOR)

    ENV.append "LDFLAGS", "-framework Foundation -framework Cocoa"
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-host-tool",
                          "--with-internal-glib",
                          "--with-pc-path=#{pc_path}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pkg-config", "--libs", "openssl"
  end
end
