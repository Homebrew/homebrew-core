class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.4.0",
      revision: "fc430c57c7b0307b4c5ffb686cd90b3c010d08d2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "621aaeb000c4ad3df7cf62af3a22f53e38d9cf0714b52cc23ee3406949c5ad0d"
    sha256 cellar: :any,                 arm64_big_sur:  "76b0b72beb6975e6f8ebbefc256f01c2b6466e210c93172c39ef35fde3945aac"
    sha256 cellar: :any,                 monterey:       "0a522c17ca7a108aa44860a549740f277fc6a1118b36df0bfd846e2d17fb80c8"
    sha256 cellar: :any,                 big_sur:        "e5f4fba0b45d08db7ffe9e06884cb163dd027b18e8ef5442cc5d4d55b6489f44"
    sha256 cellar: :any,                 catalina:       "10be5b52fb09dc2126ac5ed93e4caa805f9224833b665aebe79c2c3d40b51e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c59073520f70de15996b3af4c0513ff1b4bde89fb33a810a9dd7a8348afa553e"
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  # `jpeg-xl` is currently not bottled on Linux
  on_macos do
    depends_on "pkg-config" => :build
    depends_on "jpeg-xl"
    depends_on "libvmaf"
  end

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    ENV.runtime_cpu_detection unless Hardware::CPU.arm?

    args = std_cmake_args.concat(["-DCMAKE_INSTALL_RPATH=#{rpath}",
                                  "-DENABLE_DOCS=off",
                                  "-DENABLE_EXAMPLES=on",
                                  "-DENABLE_TESTDATA=off",
                                  "-DENABLE_TESTS=off",
                                  "-DENABLE_TOOLS=off",
                                  "-DBUILD_SHARED_LIBS=on"])
    # Runtime CPU detection is not currently enabled for ARM on macOS.
    args << "-DCONFIG_RUNTIME_CPU_DETECT=0" if Hardware::CPU.arm?

    # Make unconditional when `jpeg-xl` is bottled on Linux
    if OS.mac?
      args += [
        "-DCONFIG_TUNE_BUTTERAUGLI=1",
        "-DCONFIG_TUNE_VMAF=1",
      ]
    end

    system "cmake", "-S", ".", "-B", "brewbuild", *args
    system "cmake", "--build", "brewbuild"
    system "cmake", "--install", "brewbuild"
  end

  test do
    resource("bus_qcif_15fps.y4m").stage do
      system "#{bin}/aomenc", "--webm",
                              "--tile-columns=2",
                              "--tile-rows=2",
                              "--cpu-used=8",
                              "--output=bus_qcif_15fps.webm",
                              "bus_qcif_15fps.y4m"

      system "#{bin}/aomdec", "--output=bus_qcif_15fps_decode.y4m",
                              "bus_qcif_15fps.webm"
    end
  end
end
