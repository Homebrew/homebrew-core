class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.14.1",
      revision: "03087864cf4bea6abb0d28f95cf7843511413d8f"
  license "BSD-2-Clause"
  head "https://aomedia.googlesource.com/aom.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "beaab63a4f1daa53422eff4e1d005b95d2240ddcd3b8bffef91a72a7ed87ade3"
    sha256 cellar: :any,                 arm64_sequoia: "9f6b4e0c537a11f17c28133df343f1057bc9d403c697400f199955ec6ff96661"
    sha256 cellar: :any,                 arm64_sonoma:  "bf2c489bfaaa9f3f844f2e2fd6a04de2befb0b98244161eb5a71e21fdac9409d"
    sha256 cellar: :any,                 sonoma:        "e35fcb414d02b4d117b2937312f42a26994103aa59fc2ab4d4e994fe366c672b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97917c790d2b14f0819ed7a16ad6a724bf62d05f8f119ced1f67f95a03796cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0161fc263c240948a6075475224a8748a3c359ab7f88d88c4a24cf913c8186fd"
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
