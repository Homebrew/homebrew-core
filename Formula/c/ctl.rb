class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/refs/tags/ctl-1.5.4.tar.gz"
  sha256 "fb84925320d053827fce965d7aeea5bb8690d7093bb083c8e3915d7a600e25fc"
  license "AMPAS"
  revision 2
  head "https://github.com/ampas/CTL.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dfa050e2d9a41d8d9b2bde93e1286f9a172ed202cc0d9f61fe81a33244f6af03"
    sha256 cellar: :any,                 arm64_sequoia: "46dad0ccf20d7fcb923bc2cfff9d592d1abd347fa0a5418947f1acacc0fc1222"
    sha256 cellar: :any,                 arm64_sonoma:  "358beba8b7c3c72f2a578ecb251ad557e2e82b9bba028680dc604296f7048d4a"
    sha256 cellar: :any,                 arm64_ventura: "2dc49c04d46726e0f208cb2fd4be22d4e1bd65eae9f33874c4aa113c54c654b7"
    sha256 cellar: :any,                 sonoma:        "2b54cfdfaa8dbbe90bce3b74e6544d991d41144878ca942d3b5b75f44dbe5e89"
    sha256 cellar: :any,                 ventura:       "8a867471142e5b9f7f14107377999df21db03c4ea8fcd06a5ff8729b97d37fec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82d4fc648be73e03f07fb79130a9eeda876df66e24a80d3050d49f4cdbaa4c3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abe0b96ef6367426b3ce5b52182f714f5f496c5d18c5a91b42e3882924d5780a"
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
