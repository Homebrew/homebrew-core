class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.23.tar.gz"
  sha256 "8050295e3a44c710e21cfa55c91c37419fcbb74d1ab4d41add330b806ab45069"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fd5666804b182d41ff81d9dace40a84a90a6d964e346b019a702d21ebc4e3eb4"
    sha256 cellar: :any,                 arm64_big_sur:  "9e85bad9dbdb1cd42ad5772a4ba6e9274a8b863a529c57eb13a0f0c85f18734e"
    sha256 cellar: :any,                 monterey:       "1421c4f2e75bc60834a8df83d377076fc2fec4eb884a189b27bf46a82291ecc7"
    sha256 cellar: :any,                 big_sur:        "45e37b7b779f4ac14d511696ebbbe68f2617b07f9a7fb51816cbc9f950716a3e"
    sha256 cellar: :any,                 catalina:       "56ddc66b9a7e87bc906194fced1a8da37ea66312074ecc65c7d11a21d50dbc2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbd86ef76bf89b8c9df4290963fad58f255fce9433670b3b579058961f1cc413"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  uses_from_macos "libpcap"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end
