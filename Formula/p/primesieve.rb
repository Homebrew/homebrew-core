class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.17.tar.gz"
  sha256 "c18fe8cef84d3cb4f1f5f37d3737999c00489fddc1b58327b61d1e31c9a5b49c"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8184f7c917acfc1468c2ed31bfe11c8def3ee9879a6861eceaabeb170e7438f1"
    sha256 cellar: :any, arm64_tahoe:       "36638f62f0aa156f4852e977bf42364bd8db89d44df3f471828322bb81dcb15d"
    sha256 cellar: :any, arm64_sequoia:     "bc63bfa1e655b6e8299b8e1b024591538c112f49e6f2d0732d1dc3d8bf381fb4"
    sha256 cellar: :any, arm64_linux:       "63f8d6c4e25c4d955abe56a19db6bb7bd0726de58fa4bebde24931a917cce45c"
    sha256 cellar: :any, x86_64_linux:      "74b2ac7d24a5819635f18b26d1182986b7258aa0bb6ccf38b9c4f8c384ec7209"
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
