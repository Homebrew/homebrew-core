class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "dc1be36d02b178e904aa91cce5c2701fe418d728f1c0a130a4196b66b087471a"
  license "Apache-2.0"
  head "https://github.com/google/cpu_features.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c20bb96f3ed6b0a436d1e5ef4352e2362668d88c119340f19d8d5566c1f1302d"
    sha256 cellar: :any,                 arm64_sonoma:  "0f8f698cad043f1c27984083dead6d7a4d133283873339078720becf5b2a2e89"
    sha256 cellar: :any,                 arm64_ventura: "17d2dc220735c2cc356c1cf995e13d8dbf5011903e2e0048c5a875ea97ead59b"
    sha256 cellar: :any,                 sonoma:        "bdd716ad8038f9dbb12d8ec5080b03330825027e023d574cf755bb8f91d300b1"
    sha256 cellar: :any,                 ventura:       "472190b6db3f3255849897768e6b90c48d2348ad52b845dae54a040893fb2ee7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30c446e08c12c07373c65c5c71e4c6268d72464d1763716a90ccaae1277a3078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50756e6931f77d6095ff2cf4606373c779f0c358315ffaa8df08d37345e3b98d"
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
