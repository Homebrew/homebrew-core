class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/v3.0.2.tar.gz"
  sha256 "5f2e60aa113ba0227175bfdcc35a75bfaffe315a8c9966a7bfe4208f9bae8e46"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1b70f0c8408fdd4989de5ab087f6352985d4c623bd96ad09d13779616a7ff80"
    sha256 cellar: :any,                 arm64_monterey: "7dcd8dc27176f7d428e6335ffc00e0f009495fbc375eb9981598a443390d80f6"
    sha256 cellar: :any,                 arm64_big_sur:  "cbc8c0ee3c71696a7d5cd901548fe0bdbff0f5847e880ef00f506ec1a2a2223b"
    sha256 cellar: :any,                 ventura:        "714bd5ce882aba69388a0eef41e445b69066f747da8202a13f10ebf9bf89788a"
    sha256 cellar: :any,                 monterey:       "831d084f21c27d6aeb6128959ffee655d83d6077fa69faba662606a880f5445b"
    sha256 cellar: :any,                 big_sur:        "096b99ab5e0f03b26e2605c2d2b4b335aa0d3924b332c91c64661298363560a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1735a12a20065f134cf0358547005cecfd6485d3446e5b3262c23d462f379260"
  end

  depends_on "luajit"

  # Fix build on Apple Silicon by removing -pagezero_size/-image_base flags.
  # TODO: Remove if upstream PR is merged and included in release.
  # PR ref: https://github.com/nifty-site-manager/nsm/pull/33
  patch do
    url "https://github.com/nifty-site-manager/nsm/commit/00b3ef1ea5ffe2dedc501f0603d16a9a4d57d395.patch?full_index=1"
    sha256 "c05f0381feef577c493d3b160fc964cee6aeb3a444bc6bde70fda4abc96be8bf"
  end

  def install
    inreplace "Lua.h", "/usr/local/include", Formula["luajit"].opt_include
    system "make", "BUNDLED=0", "LUAJIT_VERSION=2.1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end
