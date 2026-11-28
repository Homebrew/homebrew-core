class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.18.tar.gz"
  sha256 "be8ee102fc248ef0ba8b8a39a9599ca623dfa17bbd10762b4533137db9c8f1f0"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    manifest_sha256 "26f3e31b903cf64c3f516a5e7553f51586fbba34612bee62e50a8b02d5627c70"
    sha256 cellar: :any, arm64_golden_gate: "a25e3c7f694151d3aa396c4d43474b0ecea355c4be3edaa60593e7aef690283b"
    sha256 cellar: :any, arm64_tahoe:       "e0f3fe02b9453bca9180c8f95ffa4b4520fec17f07c4c84fbe9e137a1477b5f5"
    sha256 cellar: :any, arm64_sequoia:     "122e0b01681fbe1dac65838a4a1216e41d2a9f1a62bd65235b865a39cb050b80"
    sha256 cellar: :any, arm64_linux:       "8959747915d45e542ad8925d39b6f9c808d2aff434df251c3532f933da522136"
    sha256 cellar: :any, x86_64_linux:      "3c7314e1d3d779cb7e6c4188a87f5d0a0d1e52cd70723a7de959200d7a01dab3"
  end

  depends_on "cmake" => :build

  deny_network_access!
  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"primesieve", "100", "--count", "--print"
  end
end
