class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.15.2",
      revision: "af3dc9aadc793c1b00edc003e3fc19a44fdeb574"
  license "BSD-2-Clause"
  head "https://aomedia.googlesource.com/aom.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ca3e34c2d919d712bdff0799bd15689ac8cbacea8d33508718a3813be45153bf"
    sha256 cellar: :any, arm64_tahoe:       "abdf34de13cbb520adaa7ea5cb3cc1f8313d281a0f456c9c39fa415cddef82a0"
    sha256 cellar: :any, arm64_sequoia:     "d8b133d6a8e7b2193f34f2f3cbc2cb327e8898331432daf2cc4cb84164871b35"
    sha256 cellar: :any, arm64_linux:       "63fef63ada9e237e795c6da37fa399a633b9b6315d7e5a470468e3455ab575bc"
    sha256 cellar: :any, x86_64_linux:      "ef4de0b57f137eecbd45f1461cc005dc46712c69f8c4a84308a3abfd85a23995"
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
