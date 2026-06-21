class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.30.0.tar.gz"
  sha256 "3555306549678c81cf2f9d0d579be75a3a2dd6798e84e7ffeddd3e219e70e062"
  license "BSD-2-Clause"
  compatibility_version 4
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a0b7e332c215868bd797495fb621b7d01ba4cd33205af1b7ced1cc79a167f6a5"
    sha256 cellar: :any, arm64_sequoia: "776303873e27fff17f397ce96e36e8d31a9fdb1f18a025436512d1dd497c9e0c"
    sha256 cellar: :any, arm64_sonoma:  "587a5669842a72082b5588143378e5467aa1f2120b8ab09325fedbc6d07ca331"
    sha256 cellar: :any, sonoma:        "9ed030b8bca1eef42575c5b24eca8255f823a8e7d756c64a131e4216f7220911"
    sha256 cellar: :any, arm64_linux:   "e45b10c4947ee27c0b33c3ef756d97ff35ba93b0722c8221df273815fbdae91f"
    sha256 cellar: :any, x86_64_linux:  "b143573a446f585fa73baf388637c132a7eca06f85ddd69fdcb465db7ce31a69"
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
