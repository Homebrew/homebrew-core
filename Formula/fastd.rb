class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://github.com/NeoRaider/fastd"
  url "https://github.com/NeoRaider/fastd.git",
      tag:      "v22",
      revision: "0f47d83eac2047d33efdab6eeaa9f81f17e3ebd1"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/NeoRaider/fastd.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e57b53023d89476d6b77a3728968bf01b72de5b3c64aa8debe8ec7a5108319e8"
    sha256 cellar: :any, arm64_monterey: "c30605764ec7c11de6d609f6d22c265799edba97bd45f41872c2e86ada1c96ca"
    sha256 cellar: :any, arm64_big_sur:  "d8bacf3dd7421a982072facb3491d05ac5cf587634bc5c8aa844077ad4da6bde"
    sha256 cellar: :any, ventura:        "89b69fa322b526c72cd3dd2d8aef8787a01ec0b26f714bc93638e120cb463236"
    sha256 cellar: :any, monterey:       "29606a6362336f9513eb57d81ac768fa085c27cbfd9ea1fbb627ced1b8535177"
    sha256 cellar: :any, big_sur:        "e83b6d48a6b1814afca9278516d0bddbd9218c252d3486bc43ef823d595e4846"
    sha256 cellar: :any, catalina:       "551d37046a7720556d1b03c0a8b829e02bb8f33783d16cef4eddd3f16e21f2c8"
    sha256               x86_64_linux:   "03fe1910df2c8c1d3a07cf9f6bc34b1c01b62fc69f495ed5a4734ba136ec4e79"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "libuecc"
  depends_on "openssl@3"

  on_linux do
    depends_on "libcap"
    depends_on "libmnl"
  end

  # remove in next release
  patch do
    url "https://github.com/NeoRaider/fastd/commit/89abc48e60e182f8d57e924df16acf33c6670a9b.patch?full_index=1"
    sha256 "7bcac7dc288961a34830ef0552e1f9985f1b818aa37978b281f542a26fb059b9"
  end

  def install
    mkdir "build" do
      system "meson", "-Db_lto=true", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/fastd", "--generate-key"
  end
end
