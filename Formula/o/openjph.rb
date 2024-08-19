class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.15.0.tar.gz"
  sha256 "36601fbd3b4e1fe54eef5e6fa51ac0eca7be94b2a3d7c0967e3c8da66687ff2c"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "30c92c986c302abea2566fb8650332b9350ea9c1e545cdefdcc845e286950b98"
    sha256 cellar: :any,                 arm64_ventura:  "e0e99c8a7c30d8bf35589afad352f70db9a745d676a0700f16f8a039ca1447ab"
    sha256 cellar: :any,                 arm64_monterey: "b2622725fd82b5b74cf56c895136384c1f4e4d0a27c6914e86a819328e6ad4ab"
    sha256 cellar: :any,                 sonoma:         "eed618cf53db8fc3f4fb6e6c2abbdaaee8998b79d51459a8f42fc7c3a7666ee9"
    sha256 cellar: :any,                 ventura:        "cdcd26be914661a3c733a8a6dc5c288ccff3bff21bd249e5f70ccc6986fcc829"
    sha256 cellar: :any,                 monterey:       "f51346472aa3f336c9e6c12e7b1c0164e884cd4897cd6cbffa4a3747b1569f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecba32ca325dbcb3529e7576a6855ee7d1f1c10713af1853708ba785e29fc98e"
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
