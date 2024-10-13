class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.17.0.tar.gz"
  sha256 "9cd09a5f3a8046b10bded787212afd2410836f9c266964a36f61dc4b63f99b6c"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a9870b3e8f2c5d3f2f43ed1143f4fbeb5e5c783a03331d34a582de2bcc0274f"
    sha256 cellar: :any,                 arm64_sonoma:  "44f608abdfd16863f76cbfdf96ba2edd4cacbba0190dbccb5256faebf854e212"
    sha256 cellar: :any,                 arm64_ventura: "2c2e8fe4da1e14469667bc7e4403fa7c94189e6806ae4d98bd67309d215882ab"
    sha256 cellar: :any,                 sonoma:        "e4bd4133c3f10bc2c7c7f727cd05e214039321b05cb7522961775ae8862c08ff"
    sha256 cellar: :any,                 ventura:       "6839bcd7ed718e5c2fadc7807152d9236e3df205ea6349388df6dd75f28c871d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6c2dcf180a76bd4265c9c1d94a1dd642167d20e777579b62bcad4c5d297b84f"
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
