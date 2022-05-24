class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.33/src/nspr-4.33.tar.gz"
  sha256 "b23ee315be0e50c2fb1aa374d17f2d2d9146a835b1a79c1918ea15d075a693d7"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "36817ecd49395967e9aab79407d26ad6146b05900cf80135204ba5e7dee11b96"
    sha256 cellar: :any,                 arm64_big_sur:  "4559755473db5d74932b2304f4be480147cf4ce1bbc2a36ab4ff1747e31dd864"
    sha256 cellar: :any,                 monterey:       "b7e83de84f2acb392f8f4a0fc95d3f2bc23e902f506c28a731e8712bfdeaf108"
    sha256 cellar: :any,                 big_sur:        "e07523d89970090c42cbf650924713fff254ecb9efcd8b1f1db5813fdde60fef"
    sha256 cellar: :any,                 catalina:       "0f08ec37a94646830d499592cc4271f562e7feb8a4ffe1522d818d0be227839b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46f42da9640c71484ca2c4f234b960efc7e2fd5002bbf0888f70311d577b35d"
  end

  def install
    ENV.deparallelize
    cd "nspr" do
      args = %W[
        --disable-debug
        --prefix=#{prefix}
        --enable-strip
        --with-pthreads
        --enable-ipv6
        --enable-macos-target=#{MacOS.version}
        --enable-64bit
      ]
      system "./configure", *args

      if OS.mac?
        # Remove the broken (for anyone but Firefox) install_name
        inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", "-install_name #{lib}/$@ "
      end

      system "make"
      system "make", "install"

      (bin/"compile-et.pl").unlink
      (bin/"prerr.properties").unlink
    end
  end

  test do
    system "#{bin}/nspr-config", "--version"
  end
end
