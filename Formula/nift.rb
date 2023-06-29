class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/v3.0.1.tar.gz"
  sha256 "c7dcac1cb56fbc5ff4ddca2eea3fa91bfa5c37a14627bac6fe638b5fde52850a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bc48fe41d74e53cce7dcf79559e23f80fb8a56e1fc87655f6f17cd0acdfaba36"
    sha256 cellar: :any,                 arm64_monterey: "166f4770d67984385d7daa9df13ec02d5a6d0fe8bb9d497b0ae219875fda86e2"
    sha256 cellar: :any,                 arm64_big_sur:  "9a842dfd3876f5f6920823cdfe985606e6c66c0488104ff7d7815106bdca6f4c"
    sha256 cellar: :any,                 ventura:        "cd80d6f99954fb2a21e37f12a27edda0967c7e190fc5e2dac3ea5a01166929e8"
    sha256 cellar: :any,                 monterey:       "8d31e774deaa806c99b4d50df531652d3b658c2f4c74aec6f054590f271f9a52"
    sha256 cellar: :any,                 big_sur:        "43ccefc3b626745ec54436451c4f99a04d4c8726a529c89480183944e29adfaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "860fd9e6c0275437b9376c2d8a9a9ecbad18c84b56cb23f57cd86927e87746f9"
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
