class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.8.2",
      revision: "615b5f541e4434aebd993036bc97ebc1a77ebc25"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aa1bb7f2f079cb576a9122dec942b45b535236318bc659380f54c5f01597d3a3"
    sha256 cellar: :any,                 arm64_ventura:  "57814016640f00145c2e39602719c69a85f66aca58cf19339281f816cc163ebc"
    sha256 cellar: :any,                 arm64_monterey: "4ab13d7d5ce273332f7158c709e34cf5ca5bfad08e1a92ebf5a6e8ef963c85f0"
    sha256 cellar: :any,                 sonoma:         "7176e4e1e257d584ab751aa3d96f1001deeb0998705b8101940a899f0b3e6284"
    sha256 cellar: :any,                 ventura:        "cfc7a2d3dbfb9e379a0aeacf96112bba69bfffbfcc550a3c8a0bea9806995648"
    sha256 cellar: :any,                 monterey:       "85b93ca7e668c4edcee3b290e8db15ae5d3008c3bdba2c4427e235ba21d6d036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "781498473798d6432b1d529760151d5d3df135f73d4211798da716edf36ad5be"
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
