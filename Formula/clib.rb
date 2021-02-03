class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.7.0.tar.gz"
  sha256 "99640506e1cf69d69451dc5d0db2d8fd169ff8247bda8c6d01dd66e9471ac6a0"
  license "MIT"
  head "https://github.com/clibs/clib.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ba2d9b6112f7a183a28e06b00bdf01c3164dbdf05b6284b5a5d8c972c4a5ef59" => :big_sur
    sha256 "b77f5026ceceec9764651778eb88f536540faaa8aa3845f7cf6bc15bd78dc0f9" => :arm64_big_sur
    sha256 "19a1b473f5c392ce7a1f8ae8209918926777f32395a31199047af6cd22ff01a5" => :catalina
    sha256 "30f21023c47efeda8c7609f7ad09de5c866e903ab85d90f11227424836fbf248" => :mojave
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
