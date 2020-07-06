class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      :tag      => "v2.0.0",
      :revision => "bb35ba9148543f22ba7d8642e4fbd29ae301f5dc"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "acbd463a00751edc0ce704bd14f493442541f4d5a2207225e9497ba4e1ce87a4" => :catalina
    sha256 "df98cc962553615767b033086833ef6f004c9b2d47062ae23d75f93013b4fba1" => :mojave
    sha256 "036d2a82eab972d1111020dddf892f94969fc39eaa0c3a1897e20b6d8b1f535b" => :high_sierra
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
