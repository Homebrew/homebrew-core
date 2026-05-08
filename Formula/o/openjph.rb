class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.27.1.tar.gz"
  sha256 "450c7af7819f86e28f810f8efb8bbe352db295b7112565ec3239f0a042bb30b6"
  license "BSD-2-Clause"
  compatibility_version 2
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9458e8b6b9626cc8f56eabb968dd16840286953249ca6f978d2679c9301884e"
    sha256 cellar: :any,                 arm64_sequoia: "9aa77bd0dae472d5e2d8cac731592d95b3512410294d1799ac34465acfbc9171"
    sha256 cellar: :any,                 arm64_sonoma:  "56ec73fe422fc4a163f9b6a4f1289eaeb0c59d56f631e32da74671fdc9260fed"
    sha256 cellar: :any,                 sonoma:        "7d665fe6d411f43280d53116394bce2f0f08f3d82663656036c8b08f129e6745"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd47c8bb60ab530139dd15305ca78e4a3f7f892a63592946d421a9a3a17f3bdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d73a7137be9ef5e82f65e2e2ed48b5a049d3e6eb1c94b7a27a0bc27f697679b"
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
