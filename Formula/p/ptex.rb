class Ptex < Formula
  desc "Texture mapping system"
  homepage "https://ptex.us/"
  url "https://github.com/wdas/ptex/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "435aa2ee1781ff24859bd282b7616bfaeb86ca10604b13d085ada8aa7602ad27"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "cfd9eb48a412ed267f3572f66012239a020db57b980e104a30a3fe6b6e2cda06"
    sha256 cellar: :any,                 arm64_sequoia:  "c51c675b7d8fcc6a5e220fae0ea0e631b186401e4979216e19e9d637f34e68a1"
    sha256 cellar: :any,                 arm64_sonoma:   "834009b39e2e8421eacc189691afe5fdfc87d1dcba237739fc88879d60c87338"
    sha256 cellar: :any,                 arm64_ventura:  "3c9c6e31882c6401c1cd08d446cec4a6ba90d1f8199230559bac04627263b8ce"
    sha256 cellar: :any,                 arm64_monterey: "8ad7824e9c1423c89c1106c9e4d5b1867c7b0bb0682ed8205520d1d5fc615d6b"
    sha256 cellar: :any,                 sonoma:         "0a99144782115f4b8d93e31f64b2002a1f40968b559514eaad1fc0667471964f"
    sha256 cellar: :any,                 ventura:        "ed39908c137c16838470243879af1d6ae1ef3441e79d30b16bf11dbb6e366dd3"
    sha256 cellar: :any,                 monterey:       "7103ad329a193ad7354dc88ca5c2292190b380c2ab133a4bb49cbbbdae29943d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9134e1db0e0fe299cc1bfe7292d8cbdad6bee6cd54513dc88d85b431850a8929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9088f4aef6f14b8a9b0ff49f5d36d18e725463e48e918ef3d7eee20b2a14618d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-wtest" do
      url "https://raw.githubusercontent.com/wdas/ptex/v2.4.2/src/tests/wtest.cpp"
      sha256 "95c78f97421eac034401b579037b7ba4536a96f4b356f8f1bb1e87b9db752444"
    end

    testpath.install resource("homebrew-wtest")
    system ENV.cxx, "wtest.cpp", "-o", "wtest", "-I#{opt_include}", "-L#{opt_lib}", "-lPtex"
    system "./wtest"
    system bin/"ptxinfo", "-c", "test.ptx"
  end
end
