class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.9.0",
      revision: "6cab58c3925e0f4138e15a4ed510161ea83b6db1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f51bfcb816a8ee87de0ca4cfee475e2e835e7f5908149d953da3d53d4e2ee254"
    sha256 cellar: :any,                 arm64_ventura:  "379497d6ad6f8e9723211e301524cf5cb927cef358b2790cd409551415a71d82"
    sha256 cellar: :any,                 arm64_monterey: "3dad44a10bb050869563dc3e485f7c033bae7dd19f9627c1e744756098f7d3f1"
    sha256 cellar: :any,                 sonoma:         "e009e72b577e5f9bcb820d226b8fdc494fe1fe9e31b1102d1e97932f27b92297"
    sha256 cellar: :any,                 ventura:        "27922a50d571a4e91f33f6880f787ec9b37009afe0996dfd8c4b21b614ce82cb"
    sha256 cellar: :any,                 monterey:       "1f6670b67d4916c879579adfaceafe92d8b9d983f3cbdad666088d4bf0ac9ca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e28cd906492ddf3e6b06b4b282bb4dc7549b5e0b51e669560c472ce56721df5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg-xl"
  depends_on "libvmaf"

  on_intel do
    depends_on "yasm" => :build
  end

  def install
    ENV.runtime_cpu_detection

    args = [
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DENABLE_DOCS=off",
      "-DENABLE_EXAMPLES=on",
      "-DENABLE_TESTDATA=off",
      "-DENABLE_TESTS=off",
      "-DENABLE_TOOLS=off",
      "-DBUILD_SHARED_LIBS=on",
      "-DCONFIG_TUNE_VMAF=1",
    ]

    system "cmake", "-S", ".", "-B", "brewbuild", *std_cmake_args, *args
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
