class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://github.com/geographiclib/geographiclib/archive/refs/tags/r2.7.tar.gz"
  sha256 "5aaca14cd75f13aa2690273d76e88e8ddf4aeb267d6be2c3e0ba948deb9ceea5"
  license "MIT"
  head "https://github.com/geographiclib/geographiclib.git", branch: "main"

  livecheck do
    url :stable
    regex(/^r(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6a55025ea7a55de13c663dd377c4038a09e45ffea33a3122111adc29038f148"
    sha256 cellar: :any,                 arm64_sequoia: "00da977f47aa6032c060f0a77ac320d739ff60c347a6f400d422308259e960ba"
    sha256 cellar: :any,                 arm64_sonoma:  "1f7b111bee4088f2566626685bb7dbcca9783a4f9770f388929e6a3e68857bf8"
    sha256 cellar: :any,                 sonoma:        "189b852fe826d044bd8c28fa0939943e966043839fc955b301e780a4fd7264fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dcd5700fcfd6cd0d72aa1cc937d75e1e9d95bb7f003467892a212839fdfe8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2077b4d7060f8b04a11c8cf2cc2a7d6a2391212e2528d7a72a4870b8287da3a1"
  end

  depends_on "cmake" => :build

  def install
    args = ["-DEXAMPLEDIR="]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
