class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.39/src/nspr-4.39.tar.gz"
  sha256 "bbd02ee87a55676063a63e5bc819e0227de2666b47307b2a0134414cdf42368e"
  license "MPL-2.0"
  compatibility_version 1

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c0433814ea6788f13f87269ed5e377bf18997d9341ff7f432afb95105b4338e"
    sha256 cellar: :any,                 arm64_sequoia: "86063b7037bebac70bc726578f1602ed20300fa88b89afce526d04b0401faedd"
    sha256 cellar: :any,                 arm64_sonoma:  "4852be684884f1a082fcc64e461432a298d841369abec07c134115263799e948"
    sha256 cellar: :any,                 sonoma:        "849901abc7d5e0f3188f99b125f5cbde59bba337e4bdb543ef0d06c7d52e917e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddb3c9945d8c15e9da26d8ff4d3e910a77076a2cdbe773890bb7e4f217c26612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b401fd2842255dad7595c67c6658098fef934dce638b667ce392340bdde5de2"
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
