class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.36/src/nspr-4.36.tar.gz"
  sha256 "55dec317f1401cd2e5dba844d340b930ab7547f818179a4002bce62e6f1c6895"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74fa5a145de56d105daeb2686e5e998a926602260b87d8bcd3d8331ae89fc313"
    sha256 cellar: :any,                 arm64_sonoma:  "7fd364727614ff8e1b09ffeafc42c616515fcc8c4c2bdcfa4df4ba216a6a2e5e"
    sha256 cellar: :any,                 arm64_ventura: "8dfb7cfb064a45c9b0d271ceebb4763c18870bc315a24edf2dfccc0cd2317356"
    sha256 cellar: :any,                 sonoma:        "4872910fad9fa87badb31ca4e531e859524c0e70fbdecdf7cb4a5b0486a062e2"
    sha256 cellar: :any,                 ventura:       "4c66879d6672278c32c08a858337dd3d430e216140afa53ffc88d85f3c47f3e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a9fbf463d239e77fb99cbb51f5eb3b918ad7d0afe1992a6f25e9c06fe439935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf40b06a4583043f75d1d4b47a27d097b412c938ba316c84749db59af7ded134"
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
