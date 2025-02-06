class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.21.0.tar.gz"
  sha256 "b327f27da75aadac89b3b37bfd310c320de2db5fe8ef8e036bce4c24678519e3"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb6991044b400ad172d4f2e75e6706ade131bffdc3d981200ef14a6309ee31e8"
    sha256 cellar: :any,                 arm64_sonoma:  "3ac8063e800e5e72e00e2c8de11106fae5e5f5525615f91bc9ca88c54c953dd3"
    sha256 cellar: :any,                 arm64_ventura: "f3362be1cff1e8821a6777e66f0cb6e5a809a63af3e5f710a90c2593cc08a92d"
    sha256 cellar: :any,                 sonoma:        "ef01cf50ce6dbb0f18191089089f86dcdab75635a6b45b3fa69832fa67eb2856"
    sha256 cellar: :any,                 ventura:       "a4af0ecef2209b5344d42cff947bdb3ba985da08e1c7a4716c01ddf9c578b1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e2534d08aaea6d5b1f604a6e94c19eae259be00ac0586cfe24604b96a26aaa1"
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
    assert_predicate testpath/"homebrew.ppm", :exist?
  end
end
