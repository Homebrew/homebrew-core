class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.38.2/src/nspr-4.38.2.tar.gz"
  sha256 "e4092faeab77bdc9b32db1113e4215948ee768e26c4666db3b5a60b35f2c9105"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3805d2575867676338bd8bdb1bb4780482a14282b6a175826937404ebd1cb4dd"
    sha256 cellar: :any,                 arm64_sequoia: "ceefc5a539beb299e3c9a57c9d7f53610bb81cba02902ed387cd5a37982ac046"
    sha256 cellar: :any,                 arm64_sonoma:  "b2cd63bc9b605523db2d1bf60c0f5f6f0d5531983ba7fcc2d3063060ebe25cbd"
    sha256 cellar: :any,                 sonoma:        "4eeb9ea3c9f202f2d35205f36bc3c36db4484ed3805ea1b1887e6c6b1f6c3c3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94d286afeb03039c370534bbe9efeb43ed42c72853541d059f0abf7624a6ae34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c6caf9854b18196ecd60afa83011882654e93b5244524962bb1389f68981231"
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
