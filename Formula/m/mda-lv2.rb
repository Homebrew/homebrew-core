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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "87a2bd9d397365ef18ac869774f67b94835d998465e5b78d4b8ec69a47a1aaa9"
    sha256 cellar: :any,                 arm64_sequoia:  "03b6f32b385004d948a37114897d206e9a879834820b54316c755c637ebdabbf"
    sha256 cellar: :any,                 arm64_sonoma:   "c2da908303e1eae13da7cc9cb09cd25664d3fd4a35d49453aa8017337cd5fb3d"
    sha256 cellar: :any,                 arm64_ventura:  "f0e9e93e3e7d6a66b7a8a123e23e41a722443899a30351938dc98bdf5f37f4ec"
    sha256 cellar: :any,                 arm64_monterey: "858cb75b9d207ea3a38a0f3752a1976bfd0c9f8bebb5f69581c9c5d0e1ea4252"
    sha256 cellar: :any,                 sonoma:         "c46a62ff1bb9377ab6a6f3f919472792e9a4b133502dcfe6f5212f7258b34ad4"
    sha256 cellar: :any,                 ventura:        "3e02aa678e179e136c89ff36a35e562d7034d5e2dbb6812f15ee024bf8deb73e"
    sha256 cellar: :any,                 monterey:       "070fccf201ecb813049b8e852808d7f05feb5f673f11ea16f6b885d10c36ef30"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dc0748c3fc037fec4e7620fcc70b40b9eb1da6e4c93ffbf617fe71555bd4110e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "688227bd6b707a8fba9ae71751c92d1267b1a6c1a3298ffc4bf57d4d04fe596f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "sord" => :test
  depends_on "lv2"

  uses_from_macos "python" => :build

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
