class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.1/chromaprint-1.5.1.tar.gz"
  sha256 "a1aad8fa3b8b18b78d3755b3767faff9abb67242e01b478ec9a64e190f335e1c"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "26dc9a1ce770ef8efe048f194d785e773a2da16b1cfe7403c9266e53f7a917c3"
    sha256 cellar: :any,                 arm64_big_sur:  "63b9b5fd1b84a9ef5b07b52e345df2b4a0802316eb24b70d59ab13519497d256"
    sha256 cellar: :any,                 monterey:       "d0b826d0914eafce9b64cd18ee118cf41f97119f644e039fb6a91f1de3e43e4a"
    sha256 cellar: :any,                 big_sur:        "02bf8ea8cea0398faa3f78383e46f7036ea572cf98f9ffe4dfe6d4580af186eb"
    sha256 cellar: :any,                 catalina:       "4d56eefb86910204094735bc1a8271136081f874bdeb30227bf03d2996951cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef289dd77b9835de98f22c0ebf9c3f6611cefbc0d13524f15acac0d8926782cd"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg@4"

  conflicts_with "ffmpeg", because: "build reasons"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    args = %W[
      -DBUILD_TOOLS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "make", "install"
    end
  end

  test do
    out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
    assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
  end
end
