class Netmask < Formula
  desc "IP address netmask generation utility"
  homepage "https://github.com/tlby/netmask/blob/master/README"
  url "https://github.com/tlby/netmask/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "f352d8117a4f9377a15919d9ad4989cfba8816958718a914abf1414242a9f636"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "526dfd6c8b4bf73f066e2f8d7e2d6dd377daf7709dfc11ba4697ed81d75ac619"
    sha256 cellar: :any,                 arm64_sequoia: "a13e322af5637a9f17320f03d2f527dff2342edae14f39c88b4b32b2962b878f"
    sha256 cellar: :any,                 arm64_sonoma:  "9b5e73835736dde2f98f6c5df24ad88a570d4a204f0b352ab35e77e36f5b7bcb"
    sha256 cellar: :any,                 arm64_ventura: "91de5bd0fb52ad88bbf873d5ee5fa3e65ef1dcf466d95aca7bad145b104bf47f"
    sha256 cellar: :any,                 sonoma:        "0fc1d11045fe492269b03b694edd9e1fe214a2208f700f5ea98d69b132914668"
    sha256 cellar: :any,                 ventura:       "37f666ef3af69e17afdabf451eb71196065e3d9e91b091f582b29be4b5c18853"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3eef7efdc4db887245360eabc57b202607d2c6cddc461ad1368898582a8eaa99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "412db2c646b5c4e9038908022c40c809e1c2430fc163dbdc27b3590db01803be"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "check"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./bootstrap"
    system "./configure"
    system "make"
    bin.install "netmask"
  end

  test do
    assert_equal "100.64.0.0/10", shell_output("#{bin}/netmask -c 100.64.0.0:100.127.255.255").strip
  end
end
