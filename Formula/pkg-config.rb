class PkgConfig < Formula
  desc "Manage compile and link flags for libraries"
  homepage "https://freedesktop.org/wiki/Software/pkg-config/"
  url "https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.1.tar.gz"
  mirror "https://fossies.org/linux/misc/pkg-config-0.29.1.tar.gz"
  sha256 "beb43c9e064555469bd4390dcfd8030b1536e0aa103f08d7abf7ae8cac0cb001"
  revision 1

  bottle do
    sha256 "236a2aa2b7f414ac36279cf5b11b9f64429c5224d8e765224a6315061f39bbaa" => :sierra
    sha256 "7354d2e9f337af437a22433926dd38a68413a8d8bef3aac52f203ae581d7669d" => :el_capitan
    sha256 "d84a72010d87c3f517a53b72a266bd5a4674efcf398eb94382621d2ee939a6b4" => :yosemite
    sha256 "7fe94019f0b3d0417bc9fffdaed1b066290cb0c051282bf6799cc589b80bb9ec" => :mavericks
  end

  def install
    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
      /usr/local/lib/pkgconfig
      /usr/lib/pkgconfig
      #{HOMEBREW_LIBRARY}/Homebrew/os/mac/pkgconfig/#{MacOS.version}
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
