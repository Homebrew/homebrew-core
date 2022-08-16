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
    sha256 cellar: :any,                 arm64_monterey: "132e996a5efb25179d000aee448ea80bf7bff90867220bda782ae068ae15f025"
    sha256 cellar: :any,                 arm64_big_sur:  "aa4738708771c5af012719e2cc512e9def376eda125bd939c6034ce9cf1142d4"
    sha256 cellar: :any,                 monterey:       "80fcaf1e645f453ade12c5e7e8ffdf2cae5ee95d3cae6ddd5fa57efbd965bac0"
    sha256 cellar: :any,                 big_sur:        "494ce940685a3ac612e204f8c82958ea13f9c925dcbe35a1f0b8e6b7579b5fca"
    sha256 cellar: :any,                 catalina:       "6b0c1734136d4bd4ac39b7cbd139c746d4997bb1042d76a8cbf326db3994f911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4f388d9428a2a4eb69a156fa03476823f2203106c6b7e877c745ac4941bf227"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
