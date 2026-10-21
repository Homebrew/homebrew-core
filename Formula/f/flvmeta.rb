class Flvmeta < Formula
  desc "Manipulate Adobe flash video files (FLV)"
  homepage "https://flvmeta.com/"
  url "https://github.com/noirotm/flvmeta/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "e1a7449d5ff1d601f85534d5acb41bcb5f6adf785473401ca755fcdfb1874c00"
  license "GPL-2.0-or-later"
  head "https://github.com/noirotm/flvmeta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31393d5899d781eda032cc8e6866a1ca948303171b1264bbc6130293183cb489"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f9db2e32066c386d1adf27b7e492c7ce7036d6b47548047b9c7c20ce4086a73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8686b1d77ca6dec644725fded64322a898bbc7e2b79a221384bac376094e1af6"
    sha256 cellar: :any,                 arm64_linux:       "9622edd977e46511e8e53b8a093e3e7a45e3886f3b3d81f0725822305079fdb5"
    sha256 cellar: :any,                 x86_64_linux:      "2a89a23f18307c66c7779c8130907a980027bf1a8676e741718ee59f23a3d699"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"flvmeta", "-V"
  end
end
