class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.37/src/nspr-4.37.tar.gz"
  sha256 "5f9344ed0e31855bd38f88b33c9d9ab94f70ce547ef3213e488d1520f61840fa"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eff1c0e6bc94e71a9c36e987c1f0156dafa9df059a2e76b421b84a8469783b0d"
    sha256 cellar: :any,                 arm64_sequoia: "016dca2d6e11881cd46b45e5630cd92d2b05f17f575c74fcf2b145813db46972"
    sha256 cellar: :any,                 arm64_sonoma:  "64ab3b08f2abdaec46516d5791ab5716545dc536ea2f8da8d62f41c81c176768"
    sha256 cellar: :any,                 arm64_ventura: "a4433f5307ebf0b42746acaae5897d6b833952b210d9d7009bd7a366e9dbc6c9"
    sha256 cellar: :any,                 sonoma:        "926173cc071ce815b2ce530b4a853d7461517531e174c4e2802387085d49c428"
    sha256 cellar: :any,                 ventura:       "91f46b8dc274b729853e605b016214c9a130706f759b33221a6d712b5a6f773c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d9f4dad664f6e761ec0b2a468b9c90a38062b5dd6c3939739ae96c173ece0c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2acd5fb0ba04b32d4e12168a048eb72800a91c1e89a247076680360f3f2a8e8a"
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
    system bin/"nspr-config", "--version"
  end
end
