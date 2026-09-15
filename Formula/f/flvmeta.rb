class Flvmeta < Formula
  desc "Manipulate Adobe flash video files (FLV)"
  homepage "https://flvmeta.com/"
  url "https://github.com/noirotm/flvmeta/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "dc0297e0e7b2cb2a044dac9cd13fa58ee3dbb3a9a6ba473b3f4d1c1787d3da78"
  license "GPL-2.0-or-later"
  head "https://github.com/noirotm/flvmeta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "374d955e41e703f408694ffff8a78caac0fb890223e6a153189316d44717c01f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "934ca1abe6fdd3758a2d1254dd3ed9214ccc1c441431a7d8c9c8843beaf8dbfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d2b5b90d3a95e7b2039d7aa430cf4d3c336e29ac77bf15bb70c1d2508eb1575"
    sha256 cellar: :any,                 arm64_linux:       "ebc838e6883dda21bbb4daec46d7f6f80d88aecbdfb30917e5c03d4e5b90a389"
    sha256 cellar: :any,                 x86_64_linux:      "5277dd8efa915221e9630aaa057b834f3222aceed3630019ab6dc90afa8383a4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"flvmeta", "-V"
  end
end
