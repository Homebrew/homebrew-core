class Libdc1394 < Formula
  desc "Provides API for IEEE 1394 cameras"
  homepage "https://damien.douxchamps.net/ieee1394/libdc1394/"
  url "https://downloads.sourceforge.net/project/libdc1394/libdc1394-2/2.2.7/libdc1394-2.2.7.tar.gz"
  sha256 "537ceb78dd3cef271a183f4a176191d1cecf85f025520e6bd3758b0e19e6609f"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f3474880ec69351e7c1622f61bebf702bc288c2a896673e40e5f862948de0422"
    sha256 cellar: :any,                 arm64_sequoia:  "78ede809109f1cdc74263480e2088879534546d1a2ef2e85abe793d9bb053546"
    sha256 cellar: :any,                 arm64_sonoma:   "36f71e3ace8c9a94a732f397eda9e2c703c8ea45f02cd9ce3a87ca5b9d961770"
    sha256 cellar: :any,                 arm64_ventura:  "38a5b54a9c968f7cf4ad345b6c679cf752c3634492158dfbe120c6f5e086cefd"
    sha256 cellar: :any,                 arm64_monterey: "48b4198b7d90c2a14d4a66075e2342c1cf4d6c03fb88670b0424a51b3dd9a4b3"
    sha256 cellar: :any,                 arm64_big_sur:  "6dc506be57b363bf54f40304cb87e0a70827786087d0bb355401a45b49121d46"
    sha256 cellar: :any,                 sonoma:         "dd54c0cb229eb1f90e63bf99b74f78e13e2d2caada3d77d3af6fdaa32fcd6022"
    sha256 cellar: :any,                 ventura:        "1b71b1a62895a6223862b1e0a0a052032c8ce358245926befec4a7a1210091ed"
    sha256 cellar: :any,                 monterey:       "5eb178bc37614499766470dda514437cbcfd00516619b7dd3d63308d0c297ec8"
    sha256 cellar: :any,                 big_sur:        "b292acc61a9a2acd0fb61b52e3d0ff624adb9c482871982cb1ebd696d581ae58"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "09b0c2e25a503714836dcf4afa1bf1f32e89cb2e3947c868d93845d8251dc046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53fba90024fafc156e594ce967d376cb60f86ca1f0fed7f3416abbc7bb023bd1"
  end

  depends_on "sdl12-compat"

  # fix issue due to bug in OSX Firewire stack
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libdc1394/capture.patch"
    sha256 "6e3675b7fb1711c5d7634a76d723ff25e2f7ae73cd1fbf3c4e49ba8e5dcf6c39"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", *std_configure_args,
                          "--disable-examples",
                          "--disable-sdltest"
    system "make", "install"
  end
end
