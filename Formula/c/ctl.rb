class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/aces-aswf/CTL"
  url "https://github.com/aces-aswf/CTL/archive/refs/tags/ctl-1.5.5.tar.gz"
  sha256 "b6a36ac31e0a79224216e4fc41b56982939cec7a1afd4e80165cec3f1c37d265"
  license "AMPAS"
  revision 1
  head "https://github.com/aces-aswf/CTL.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "400c29e424a05b0898c56e6455d67b71cdbc53c969354f980018fc1e95cb9c0f"
    sha256 cellar: :any, arm64_tahoe:       "3035799ef4261b9bb5ea6aa0d849eac318792c4e07cda89d260b97e0e75219da"
    sha256 cellar: :any, arm64_sequoia:     "51a985402e336b1a42885d2b9a1f0b9439e13be1868d3136472e79e7e1b45d8c"
    sha256 cellar: :any, arm64_linux:       "18d9a39c698a67b53092e9d65bb8ac1ec1c9956bff29c583e2d2f1f94063eca4"
    sha256 cellar: :any, x86_64_linux:      "47325aad92767d26fc02154cb3815616a0474e6408db1d0ddf86a798b550a064"
  end

  depends_on "cmake" => :build
  depends_on "imath"
  depends_on "libtiff"
  depends_on "openexr"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCTL_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "transforms an image", shell_output("#{bin}/ctlrender -help", 1)
  end
end
