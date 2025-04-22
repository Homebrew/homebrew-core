class Libversion < Formula
  desc "Advanced version string comparison library"
  homepage "https://github.com/repology/libversion"
  url "https://github.com/repology/libversion/archive/refs/tags/3.0.3.tar.gz"
  sha256 "bb49d745a0c8e692007af6d928046d1ab6b9189f8dbba834cdf3c1d251c94a1d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f392a811f7f8c33d3215c42acc3162b8e4eb969ef2035b9cd1848b565a4aaa3c"
    sha256 cellar: :any,                 arm64_sonoma:   "71d067178dfa687afa51f634d5b95c5e8c7207de51ef57625bf4de2e64f7b7a8"
    sha256 cellar: :any,                 arm64_ventura:  "678f93db1e9a2a5eea319f8e617ca98649f699c49753e53b463ad0c53c4ca6d2"
    sha256 cellar: :any,                 arm64_monterey: "a1c1177a83175a7084eb350560728ec8d9b98985a7e0a17f9df29e2149da71d0"
    sha256 cellar: :any,                 arm64_big_sur:  "f02d597938633f6b90e8096fb643e222f45d3d7091705b2292d2cd57eb975c9c"
    sha256 cellar: :any,                 sonoma:         "04aa6caddb7a975f76e48ed1ec6b3b7caee628a08dd6f84ea9841daa7b36737f"
    sha256 cellar: :any,                 ventura:        "55214b46e71ca86a53fced6ec189f5d5d88f1683534578816562c0ea59b23f65"
    sha256 cellar: :any,                 monterey:       "f4f9d55d39e551756a77055b77108b65f2aea9bc2d8f3bb0eaa13b3f6023c142"
    sha256 cellar: :any,                 big_sur:        "3b8a9af1caeeba055c351dd7b39fec1cc2adc3e7dd125c63bebcbc06c3cce9f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "376dd65501387cfc8c9b69e4e8d58e41e157020a061e62ddfab8583ca18843ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "244074a47f2d78925338b7e54defef0b35a250c50e4cd0ae4247c5c659a7c87f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "=", shell_output("#{bin}/version_compare 1.0 1.0.0").chomp
    assert_equal "<", shell_output("#{bin}/version_compare 1.1p1 1.1").chomp
    assert_equal ">", shell_output("#{bin}/version_compare -p 1.1p1 1.1").chomp
  end
end
