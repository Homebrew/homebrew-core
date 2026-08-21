class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.40/src/nspr-4.40.tar.gz"
  sha256 "c0c1884c627f3db7a783f7c7314c695226b2043696791d15519e7e0578c19bdc"
  license "MPL-2.0"
  compatibility_version 1

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5dcb6d1b73ec8c839dacd46dfad6d34ab2cde7339593e106aaccc20cf72ddb62"
    sha256 cellar: :any, arm64_sequoia: "afa910ba680a2a951e5e624ff83f756ba7a53a2647cb1aabdf602cb94468eee2"
    sha256 cellar: :any, arm64_sonoma:  "3025c0bd9a1ed60c1aedffb36475e0eef6a4666500959cf2386ca7180a9d7db3"
    sha256 cellar: :any, sonoma:        "33eb0744b19504a815418fea946241fa63823ca513ac5be37a033429a0422ccf"
    sha256 cellar: :any, arm64_linux:   "cd749cf5e8f3c20589baeab68214f55b5a9e39207bc4d39ba127a4e4b686a984"
    sha256 cellar: :any, x86_64_linux:  "0922c5d8889e433afa933295c1627185d6d92f2c87d422d6d6a84e074bf6340b"
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
