class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      :tag      => "v1.0.0",
      :revision => "d14c5bb4f336ef1842046089849dee4a301fbbf0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1c49d2f8eee438f057d689a3ac68af545e4462ebd2db2fdd9a749fb6a1842da7" => :catalina
    sha256 "f326a5ea77c38ea80d81c6302d6e2d314a7407d036f881bf4783cf3d757bb473" => :mojave
    sha256 "fedb7991299e8e84ed4ce94ad3cc161951aa10d3044fc9446009046d17eb1e2f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    # Work around Xcode 11 clang bug
    # https://bitbucket.org/multicoreware/x265/issues/514/wrong-code-generated-on-macos-1015
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    mkdir "macbuild" do
      system "cmake", "..", *std_cmake_args,
                      "-DENABLE_DOCS=off",
                      "-DENABLE_EXAMPLES=on",
                      "-DENABLE_TESTDATA=off",
                      "-DENABLE_TESTS=off",
                      "-DENABLE_TOOLS=off"

      system "make", "install"
    end
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
