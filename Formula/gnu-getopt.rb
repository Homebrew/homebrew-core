class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.1.tar.xz"
  sha256 "890ae8ff810247bd19e274df76e8371d202cda01ad277681b0ea88eeaa00286b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b1d5a34f4173e378efff2e2d2f77d9a817259548558bfe40bd4c18740f99ed6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad2d4903fae9b13cbacb8091fdd2555c8ee2bf9ff4d665b92a7eb4242b7c139d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "375e7abe811e322fd6db77e27dcd732daa081908affc1ffad72a972bf94d9968"
    sha256 cellar: :any_skip_relocation, ventura:        "d103ac1b953fae8d9edb145aa1a22d0599f32b38591adc613da26da02ad450a9"
    sha256 cellar: :any_skip_relocation, monterey:       "22d5eca1331582a051a5370c093969d219880641c5f1501b96b76f592fc422ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd9962ac153ce0142d90c46e0add261fe01927377b7e803bf606a64809237620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1466fbd1137ebc2d3c58f2c2256501400b94bf2aad6fb4cf23bfe6b1cea16348"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    keg_only "conflicts with util-linux"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
