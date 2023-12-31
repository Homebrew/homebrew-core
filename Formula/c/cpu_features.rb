class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "bdb3484de8297c49b59955c3b22dba834401bc2df984ef5cfc17acbe69c5018e"
  license "Apache-2.0"
  head "https://github.com/google/cpu_features.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ce0a600098af980c41651295e62323e64312fc784b58894d8dda0c8ee3af7257"
    sha256 cellar: :any,                 arm64_ventura:  "a553042b0852ac60b9ffa9d84f1651316a2425a8eeb8c7e031850ef7d1d4b142"
    sha256 cellar: :any,                 arm64_monterey: "3b46124865d45cc7f9521e220bfa6d812fe2c72db6cb11cd5b100ae78bf7eefc"
    sha256 cellar: :any,                 sonoma:         "4c6fdef575b3acac228f0b880dd7d1154dffbafac08df0bafd82d1630ab8b722"
    sha256 cellar: :any,                 ventura:        "3598175140e64a33064ae94b81e3ef252051313acc4344a7e7ff42fc891a3c79"
    sha256 cellar: :any,                 monterey:       "750715774bcd3306efac26b9b5173c9126b8a25613e7fc54100cf5814ef7cdcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d728f5f093b6666edcba57a77aa36e9f9dc6949634fd9a1e76f55ec5abadd4a8"
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
