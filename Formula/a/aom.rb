class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.13.3",
      revision: "92d4c37fbdd08944a0e721bbaeb13318f10aebb0"
  license "BSD-2-Clause"
  head "https://aomedia.googlesource.com/aom.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5732d2c4ce27812b3954b48119d31a2bfcb73c891800f2218f84ca5d6a525490"
    sha256 cellar: :any,                 arm64_sequoia: "8b6d724c032db9499a90806406b0df155e405d85357e071ba79e9d8586f76486"
    sha256 cellar: :any,                 arm64_sonoma:  "301f6461f3406e257b2b33facb48cd6df146f6de57be2dc1de24f9e5699e8bb7"
    sha256 cellar: :any,                 sonoma:        "a7d2815367a7897ddea6704e97de75b5b65f633607a994b5a96c6ee2e96a9ed6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1edd769ce48b73437ba4bfc374d5455850a7a6d50b09a53ac11f110daaceb7c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6aff200f4c09e2e793f56843f74d1776a85d2ffd7162b7955cd1a8ee5162743"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libvmaf"

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    ENV.runtime_cpu_detection

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_DOCS=OFF
      -DENABLE_EXAMPLES=ON
      -DENABLE_TESTDATA=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_TOOLS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCONFIG_TUNE_VMAF=1
    ]

    system "cmake", "-S", ".", "-B", "brewbuild", *args, *std_cmake_args
    system "cmake", "--build", "brewbuild"
    system "cmake", "--install", "brewbuild"
  end

  test do
    resource "homebrew-bus_qcif_15fps.y4m" do
      url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
      sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
    end

    testpath.install resource("homebrew-bus_qcif_15fps.y4m")

    system bin/"aomenc", "--webm",
                         "--tile-columns=2",
                         "--tile-rows=2",
                         "--cpu-used=8",
                         "--output=bus_qcif_15fps.webm",
                         "bus_qcif_15fps.y4m"

    system bin/"aomdec", "--output=bus_qcif_15fps_decode.y4m",
                         "bus_qcif_15fps.webm"
  end
end
