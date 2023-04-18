class MdaLv2 < Formula
  desc "LV2 port of the MDA plugins"
  homepage "https://drobilla.net/software/mda-lv2.html"
  url "https://download.drobilla.net/mda-lv2-1.2.10.tar.xz"
  sha256 "aeea5986a596dd953e2997421a25e45923928c6286c4c8c36e5ef63ca1c2a75a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?mda-lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6d241076e433268cb541caec4a74ee61aabaeb056717bf76cc219352895b7a08"
    sha256 cellar: :any,                 arm64_monterey: "e780aa5e6c3d9374a120635996ee851a35191919eda1156ffdc5855bc5f927b4"
    sha256 cellar: :any,                 arm64_big_sur:  "b57083c5363f020da2ff8f41756b63ff03800a82691c76141d3a48f5eabc2872"
    sha256 cellar: :any,                 ventura:        "69214dc90ea0b35a252852a86d0060c496c5394e25704361f2fb4653cafed564"
    sha256 cellar: :any,                 monterey:       "a07ff2fc6086254b1fd4d122505cea924a2501d2c45a458dbc3112b696cdfd67"
    sha256 cellar: :any,                 big_sur:        "036d0587dc2d24728b21dcbf2b2d791aea14f12751ecb376d8517c997c863ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69241d7a0f0124ccae0386c423635981756703bd48d8471e0426a8572469b30a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "sord" => :test
  depends_on "lv2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    # Validate mda.lv2 plugin metadata (needs definitions included from lv2)
    system Formula["sord"].opt_bin/"sord_validate",
           *Dir[Formula["lv2"].opt_lib/"**/*.ttl"],
           *Dir[lib/"lv2/mda.lv2/*.ttl"]
  end
end
