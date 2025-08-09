class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/refs/tags/ctl-1.5.4.tar.gz"
  sha256 "fb84925320d053827fce965d7aeea5bb8690d7093bb083c8e3915d7a600e25fc"
  license "AMPAS"
  revision 1
  head "https://github.com/ampas/CTL.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3fb1b09436b484e35d5544ff6bf9f2a9c5366168688f5bf99adfbddb65d5dd28"
    sha256 cellar: :any,                 arm64_sonoma:  "d3d274bbebd059bc200982df81a41ec44d7ec6e034ea68b270061f65066f5835"
    sha256 cellar: :any,                 arm64_ventura: "cb1106d92d6a4796b1d991fa02ecc5e64d1f36a838dec83ba55592d5a542c9f6"
    sha256 cellar: :any,                 sonoma:        "17ec28c686ab557397d8eed4372422118ac398d7cd550a56a5bd8a13522edb69"
    sha256 cellar: :any,                 ventura:       "98e9048d39c5c6a1db7cbfaf1499a98b9223a68a163b653428bf32813857af81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f8da736a028805ef0a72fd237280d1aa6c267bec62d94bd5a330c884024f787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99cf99049b9a220373d99678ed562fcc3e5fbc9b795df7b4e158dce5d157f8a5"
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "imath"
  depends_on "libtiff"
  depends_on "openexr"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCTL_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "transforms an image", shell_output("#{bin}/ctlrender -help", 1)
  end
end
