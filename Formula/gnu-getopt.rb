class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.tar.xz"
  sha256 "9e4b1c67eb13b9b67feb32ae1dc0d50e08ce9e5d82e1cccd0ee771ad2fa9e0b1"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "729d02eac3c092be7dec5d8d3c0f0fc813e729a94a955f1bbc56d416fc410ef1" => :catalina
    sha256 "080e1a67f6efa6ab711e300366969ae63d4b3b533bde7f5347b35c2337e20e2e" => :mojave
    sha256 "4e9566ba6ef6f6bf8f3a261ae1802f621198122e227512c65ddd9bf5d2415ab4" => :high_sierra
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
