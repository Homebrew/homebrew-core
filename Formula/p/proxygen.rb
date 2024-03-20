class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.03.18.00/proxygen-v2024.03.18.00.tar.gz"
  sha256 "060277cf32309fb0c0a1a5fca772500015ffb53a3b9f31534aaa50d27e80c9d3"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7c64e8e5d9795bd2ae28703fdf2b9b67fd70f6aed3f13f63543cabcf03db6b94"
    sha256 cellar: :any,                 arm64_ventura:  "ccb1e8766f9b5dce13255a905d33948cb4851ea1653c7a4274af91c97a45875f"
    sha256 cellar: :any,                 arm64_monterey: "e9fcd6caf12a745bc278f53531030a42b915edff4da9e9c8394261280cf49120"
    sha256 cellar: :any,                 sonoma:         "6469a38df207b45116d669d54860233db8a6554b3a25eaefa97326fabd3f7056"
    sha256 cellar: :any,                 ventura:        "07aa48b267929553ce24393ab4905c8dcf29ab53e3b7c06e5555073b9075f554"
    sha256 cellar: :any,                 monterey:       "19139b205d22db54f2e740fd6c02ab35d4a30645fb52e3b57b65732a82772009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc0b57e9a04046a137389731cd88410ae774d567122877169bb6388a04d13ef5"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pid = spawn bin/"proxygen_echo"
    sleep 5
    system "curl", "-v", "http://localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end
