class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.30.1.tar.gz"
  sha256 "fb3ccf71af838ed2a42c6ea669308a2adaba115ae9d5862dfb1e2865b43eb5b8"
  license "BSD-2-Clause"
  compatibility_version 5
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dbe3f0d222b5dbdc8945e6e2b262721891accf8cce18983c44673ce929137664"
    sha256 cellar: :any, arm64_sequoia: "735b089cd312a0903cd1930c65819f157eea6fc28df4307ba30e763e05cff2e9"
    sha256 cellar: :any, arm64_sonoma:  "a038a03fcffd619be76546746b8210e4836a589724589a98d7efbf8530c7a14b"
    sha256 cellar: :any, sonoma:        "5f8f814a5f267c0490f0a68b9a87385b68768124d75eae660a733d917b0567e3"
    sha256 cellar: :any, arm64_linux:   "d4794bcedd717eb5b9676d0984e4ee32252fa7916f2037b27c778933cae3edc2"
    sha256 cellar: :any, x86_64_linux:  "8acb63b096e601e4b571014ba4428e7f41bef30b5cec942169b91f26f5bf3be2"
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
