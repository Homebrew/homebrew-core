class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.12/gupnp-tools-0.12.0.tar.xz"
  sha256 "5ea7607ee365642c555927fedc5b5e1fe08e74f061d0c3eb08bd901b5eb20082"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    sha256 arm64_ventura:  "1f77de35111b7692dfd08698c1bc4fbcbe31a805e4b57fc024cd035a387013e6"
    sha256 arm64_monterey: "844b38b4ff401630a7eb6179f27b5956813384b0998be103ef77a9f6db50c055"
    sha256 arm64_big_sur:  "9981f6e218dffe3ea6c4671a0fd687c382c2970b2ccecc6cbe0fe37ccda008eb"
    sha256 ventura:        "145aeeeb785b8a016f9e681557f0ada9023dd09c7533a6c0e78a989f18a96018"
    sha256 monterey:       "d499f054d2cadfab9cec927284520132de959775621e73b39565fb207578978c"
    sha256 big_sur:        "8fbd79cb92afcd3edd993c2b2e642ab8c85a1fa2a4322d2e9ed896407fcae063"
    sha256 x86_64_linux:   "d6e4305011d3e9a19a51917779b3daada8aa653e72049c93c3dc90b78e2a7a99"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gssdp"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "libsoup"

  def install
    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/gupnp-universal-cp", "-h"
    system "#{bin}/gupnp-av-cp", "-h"
  end
end
