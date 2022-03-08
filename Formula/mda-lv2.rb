class MdaLv2 < Formula
  desc "LV2 port of the MDA plugins"
  homepage "https://drobilla.net/software/mda-lv2.html"
  url "https://download.drobilla.net/mda-lv2-1.2.6.tar.bz2"
  sha256 "cd66117024ae049cf3aca83f9e904a70277224e23a969f72a9c5d010a49857db"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?mda-lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "be90e08c58a3300485e41b72ce72911e5eba897023a14a69aff4a1b599e900bc"
    sha256 cellar: :any,                 arm64_big_sur:  "6993a3e9c831ee18705dc648a7ce96db6bbec3527f872847ed2de2b47d3ed2ca"
    sha256 cellar: :any,                 monterey:       "c056cab2b7cdfb21b75ddd7e8582614f9e3240d82fc573a2b1e8558e4a8dd965"
    sha256 cellar: :any,                 big_sur:        "0d67451b324decf5a25c46e03ee5d498338fe84d331c7779746da8f9964f4d11"
    sha256 cellar: :any,                 catalina:       "6568406b88d52d06ec8dd26a31b43716b15c7782f05871894d211ea1ff66b82b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa6b5b92eb36d3dc33c0fa271c2fd61ba0986737a8dc4097682c88d9862ae8ce"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "sord" => :test
  depends_on "lv2"

  def install
    ENV.cxx11
    system "python3", "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{lib}/lv2"
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    # Validate mda.lv2 plugin metadata (needs definitions included from lv2)
    system Formula["sord"].opt_bin/"sord_validate",
           *Dir[Formula["lv2"].opt_lib/"**/*.ttl"],
           *Dir[lib/"lv2/mda.lv2/*.ttl"]
  end
end
