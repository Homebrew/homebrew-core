class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.34/src/nspr-4.34.tar.gz"
  sha256 "beef011cd15d8f40794984d17014366513cec5719bf1a78f5e8a3e3a1cebf99c"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0fb44c31fa21aee523a8bfb2a5736a7fe29f998591b418b0e3c949a1cd6cbe9d"
    sha256 cellar: :any,                 arm64_big_sur:  "83b1f509c6257103ab0b022236a23b1c5fb745df164dbc784a99264ef0245cd2"
    sha256 cellar: :any,                 monterey:       "b8ae4eda189dcb259f3cec381a89882aa6cfa0ffab48f3788ed642d3d8da3db0"
    sha256 cellar: :any,                 big_sur:        "c774c50ead25959801c98215698cbeed7b325d1d867757afdb50dbcb3d38bf49"
    sha256 cellar: :any,                 catalina:       "2d4e20e62a6d733cda09359f7a50ea99f7a9e356b3687a7766b753f75d2b7e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92d640f90688994ccaf682e2090dd6e8b4dc01f957332f98da622aa1aab8cb39"
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
