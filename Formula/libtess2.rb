class Libtess2 < Formula
  desc "Refactored version of GLU tesselator"
  homepage "https://github.com/memononen/libtess2"
  url "https://github.com/memononen/libtess2/archive/v1.0.1.tar.gz"
  sha256 "2d01fb831736d04a9dd2c27cbe8d951f15c860724cd65a229fa9685fafce00fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "14aca1077e6ddb6e531620a30d9792d1f2f8b0ff87d253d820ef2ee3f451d433" => :sierra
    sha256 "3eff3e41e6ca76c0e2716615793015781b52e44a851c30b15b38ac769dfebbc6" => :el_capitan
    sha256 "193dbb1598352e0d24501bb5c5a8a52236e2e6675d4473e357a46a7b4c644b9e" => :yosemite
    sha256 "b6cbf42008dcc423a8c9026e8f9dbec777dde7d375dbebd2817fc5b9393f1f85" => :mavericks
  end

  depends_on "premake" => :build

  # Move to official build system upstream rather than hacking our
  # own CMake script indefinitely.
  patch do
    url "https://github.com/memononen/libtess2/commit/a43504d78a.patch"
    sha256 "2b05d81ae67e121b578d1fceeea32a318628c63de4522aeba341e66a8b02f5b3"
  end

  def install
    system "premake4", "--file=premake4.lua", "gmake"
    cd "Build" do
      system "make", "tess2"
      lib.install "libtess2.a"
    end
    include.install "Include/tesselator.h"
  end
end
