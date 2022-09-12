class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.35/src/nspr-4.35.tar.gz"
  sha256 "7ea3297ea5969b5d25a5dd8d47f2443cda88e9ee746301f6e1e1426f8a6abc8f"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "89cac57fbae8797d10169e7357708df8c8c9dd4aafe3c3984555f4a3389a61dc"
    sha256 cellar: :any,                 arm64_big_sur:  "4a8dcae8d968c3162a0a07f30f7c0d790008d831e34cb76c1a23a62b5c17ff26"
    sha256 cellar: :any,                 monterey:       "80ac7f5e86707a572042ea4ad5a92180fd4fb3569bd784dff647408958c704b3"
    sha256 cellar: :any,                 big_sur:        "765c92a1aebb2732c1c544dec207408032821f3997a1b09de222bdc4f46ba1c0"
    sha256 cellar: :any,                 catalina:       "d5ac9d5cfaa2685822266aba63c5916d3ba078e77e7e508e0929e195f78bd1cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94441b578bd30e4ed732141a1df18dba2738486ceb324b4ed302f006a11b2393"
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
