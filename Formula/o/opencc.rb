class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.1.1.9.tar.gz"
  sha256 "ad4bcd8d87219a240a236d4a55c9decd2132a9436697d2882ead85c8939b0a99"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f626f8c96d7400b2836598e82243b070c9b3cbaf6e2aaa259bec3bf7d0adf1e4"
    sha256 arm64_sequoia: "8b6b0e9d88ffeecb82287510d3416101529d017851b0b537f9e6b541673bed66"
    sha256 arm64_sonoma:  "6f5005829e63d7db587d1018470b02707ce5e47a1f253543877f7285f5a0b3eb"
    sha256 arm64_ventura: "2563f2f90b6080cee6831a5873833064f03f34fad8af3c127f16ffe08a4d4376"
    sha256 sonoma:        "c04a149eacdc804adb89854db53fae7634aa4af832537dbe5ed9d032760f7fee"
    sha256 ventura:       "8a29fb0a0fe27a67c687f7ce0577fd9b8e7d4dc0574dc45af0d8f1ad4be2db95"
    sha256 arm64_linux:   "495cf421bfc4bdd7e449cb75e9e04648f86a29734e4ae38597c27a2e626956dd"
    sha256 x86_64_linux:  "9b7d0f7d8b7113014476146573c883666708cceba92f389a1cb9e0c3225c6337"
  end

  depends_on "cmake" => :build
  depends_on "marisa"
  uses_from_macos "python" => :build

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON_EXECUTABLE=#{which("python3")}
      -DUSE_SYSTEM_MARISA=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    input = "中国鼠标软件打印机"
    output = pipe_output(bin/"opencc", input)
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "中國鼠標軟件打印機", output
  end
end
