class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.1/chromaprint-1.5.1.tar.gz"
  sha256 "a1aad8fa3b8b18b78d3755b3767faff9abb67242e01b478ec9a64e190f335e1c"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "aa386d4b1b6e459cbc3278df211e69afc968335b0fa47879376ded5f1d319666"
    sha256 cellar: :any,                 arm64_ventura:  "5817ff57c800830742cc5e219ebbbefc8ff8d3d2a1a485a6697a5cf846616387"
    sha256 cellar: :any,                 arm64_monterey: "768762a92999548af504757a15a26491141d22f76fd097be3e5843c9f4daa2fe"
    sha256 cellar: :any,                 sonoma:         "f50a89f5bd62d29d48851b936bf5c305ad48458fe2205e852210b22131bdec52"
    sha256 cellar: :any,                 ventura:        "223831c28408d05ff1e514f49684c35e31e02737ce3036ad86e57454b0d3da8e"
    sha256 cellar: :any,                 monterey:       "2985d28cf2f578ab3a0d76d5d0dbe594d0f2d5ca7a9a433cf32d47ae25d8483f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b83c08025debf7cbed075ea7be46b89ff26658c291bd3621d8732f7713c3034"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  # Backport support for FFmpeg 5+. Remove in the next release
  patch do
    url "https://github.com/acoustid/chromaprint/commit/584960fbf785f899d757ccf67222e3cf3f95a963.patch?full_index=1"
    sha256 "b9db11db3589c5f4a2999c1a782bd41f614d438f18a6ed3b5167165d0863f9c2"
  end
  patch do
    url "https://github.com/acoustid/chromaprint/commit/8ccad6937177b1b92e40ab8f4447ea27bac009a7.patch?full_index=1"
    sha256 "47c9cc257c6e5d46840e9b64ba5f1bcee2705eac3d7f5b23ca0fb4aefc6b8189"
  end
  patch do
    url "https://github.com/acoustid/chromaprint/commit/aa67c95b9e486884a6d3ee8b0c91207d8c2b0551.patch?full_index=1"
    sha256 "f90f5f13a95f1d086dbf98cd3da072d1754299987ee1734a6d62fcda2139b55d"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TOOLS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
    assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
  end
end
