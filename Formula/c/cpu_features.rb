class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "52639b380fced11d738f8b151dbfee63fb94957731d07f1966c812e5b90cbad4"
  license "Apache-2.0"
  head "https://github.com/google/cpu_features.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd159612cdd2ab4419b292cc51c82f58faf76bf9914958b5e9349f35ab2c3ac5"
    sha256 cellar: :any,                 arm64_sequoia: "945475dbda6e53ed6b0099e872921e81866dc0417ff7374afd0d6338d382eb0a"
    sha256 cellar: :any,                 arm64_sonoma:  "735d42534147a399b2918ed40ee5cabcb2766a5c2eadbd02cb22208f296184c5"
    sha256 cellar: :any,                 arm64_ventura: "e2e94da759d6d2f19a74806f3892dc53d737bdc487438c7e600863b1873230c2"
    sha256 cellar: :any,                 sonoma:        "473045353940853796b7698a7fb015255acd4fba2721ae20440669a7cf6fed51"
    sha256 cellar: :any,                 ventura:       "e5e805ca6fae1c04da955ebfd6eac72e60f28eee7219a51d91bda7a7340d1ed3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a88007b4da1b4346f18463e45ab8722c8177f62155ba53fd7cd8451145ef1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f4909cd169aaa589c4f32fb189f6457127355b2064689303bf96a720c120494"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Install static lib too
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libcpu_features.a"
  end

  test do
    output = shell_output(bin/"list_cpu_features")
    assert_match(/^arch\s*:/, output)
    if Hardware::CPU.arm?
      assert_match(/^implementer\s*:/, output)
      assert_match(/^variant\s*:/, output)
      assert_match(/^part\s*:/, output)
      assert_match(/^revision\s*:/, output)
    else
      assert_match(/^brand\s*:/, output)
      assert_match(/^family\s*:/, output)
      assert_match(/^model\s*:/, output)
      assert_match(/^stepping\s*:/, output)
      assert_match(/^uarch\s*:/, output)
    end
    assert_match(/^flags\s*:/, output)
  end
end
