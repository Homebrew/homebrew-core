class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.26.2.tar.gz"
  sha256 "979dbea44fe6b6b233d08226caa0311549948a4b5d0817bb20d82cbd8bd7a30f"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc59829267d264451f060a294c78754f720356a5c95d62e82140598f87d81fd8"
    sha256 cellar: :any,                 arm64_sequoia: "199d396d831b5456be7446df944e063c2ead0d352c02998079dc5a0ea9c59007"
    sha256 cellar: :any,                 arm64_sonoma:  "162249af3ee64bc3bb10be11f333407b6ecd8161f6368bbf3c01dd52ddb489cf"
    sha256 cellar: :any,                 sonoma:        "411a991150ea9d7437ad6eff5d47b1417347b4dbce92ae092455f2b3712fea84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdde22ab8f250e7e8758b024c8ff63b98773381c654e7c697480be3316e408d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18499572ce321957d930891428d3b72521ad15261258704dbf7a996a8c9269b6"
  end

  depends_on "cmake" => :build
  depends_on "libtiff"

  def install
    ENV["DYLD_LIBRARY_PATH"] = lib.to_s

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test.ppm" do
      url "https://raw.githubusercontent.com/aous72/jp2k_test_codestreams/ca2d370/openjph/references/Malamute.ppm"
      sha256 "e4e36966d68a473a7f5f5719d9e41c8061f2d817f70a7de1c78d7e510a6391ff"
    end
    resource("homebrew-test.ppm").stage testpath

    system bin/"ojph_compress", "-i", "Malamute.ppm", "-o", "homebrew.j2c"
    system bin/"ojph_expand", "-i", "homebrew.j2c", "-o", "homebrew.ppm"
    assert_path_exists testpath/"homebrew.ppm"
  end
end
