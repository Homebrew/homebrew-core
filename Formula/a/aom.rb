class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.15.3",
      revision: "b141d9c45db236335351c8a4b2a14b3ade27c937"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://aomedia.googlesource.com/aom.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "62c6e88627ca648845e877164e637feb66e64fbcc95a839f1f4a484fdfa359cd"
    sha256 cellar: :any, arm64_tahoe:       "1700f28827f8c737481b7f0b702aadd0c2c760108a3cf9fa8c227e4bfe17e518"
    sha256 cellar: :any, arm64_sequoia:     "39acbc6e2fc0c0e02623a314fc1247153288cd4c30d8945e45e4629da963f784"
    sha256 cellar: :any, arm64_linux:       "aa0af3f40be623f4b538464c2040f5c67f065de387833cda57c4c7e91a499e5e"
    sha256 cellar: :any, x86_64_linux:      "1e3c1c9925e655d8c21273ff97ee8828d9162a837f58cf503e5bb0e77ba46e02"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libvmaf"

  on_intel do
    depends_on "nasm" => :build
  end

  resource "homebrew-bus_qcif_15fps.y4m", :test do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  allow_network_access! :test

  def install
    ENV.runtime_cpu_detection

    # TODO: report upstream
    # `snprintf` gets the whole buffer size as `cur` advances, aborting under `_FORTIFY_SOURCE`
    inreplace "common/webmenc.cc",
              "snprintf(cur, total_size,",
              "snprintf(cur, total_size - (cur - result),"

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
