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
    sha256 cellar: :any,                 arm64_sonoma:   "64c2270786c71c700dce08a8abb8f8e626fae6b1f09f44f4e932491447e0e858"
    sha256 cellar: :any,                 arm64_ventura:  "f687611cbb5d48ff8a9e5312eebac9f12f31fb700c3cc1f5a8d2732c0cae9afc"
    sha256 cellar: :any,                 arm64_monterey: "466fd0ffb45153ddc9ce8d882440bc3f2c9c2e1e5ff1caf00ea3e5a7f2dbff0c"
    sha256 cellar: :any,                 arm64_big_sur:  "2e3a32904cb5f089c1dba35df40a81513b2519c1e33b5b29af0c06a639cc554f"
    sha256 cellar: :any,                 sonoma:         "dd2f50c1f3b6329df544dfd372e385d9379234c0ac45652a0388d285e7111455"
    sha256 cellar: :any,                 ventura:        "230771659d8bd6227c5cd2b7dbb89953d02a0b0646a80d4ac0920782990e98fb"
    sha256 cellar: :any,                 monterey:       "7b4bd4b9800bad2ae7322c125defee4da9a94a2cc6abeb6c3897af64a8f023a3"
    sha256 cellar: :any,                 big_sur:        "9c50db49ddcd26100b885dc4054ac7c2fd4559012eedc1fdaf4b4d03145ce10f"
    sha256 cellar: :any,                 catalina:       "4310f8360717b354f2e29eb205d7de77a34d83a7d9c08addaa85c7fba397ed6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "592605a1cac69bf9728b59f9deb9b4fcdcc77461d44cabcd6f59669f77278b08"
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
        --enable-64bit
      ]
      args << "--enable-macos-target=#{MacOS.version}" if OS.mac?
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
