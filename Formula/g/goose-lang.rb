class GooseLang < Formula
  desc "Goose programming language compiler"
  homepage "https://aardappel.github.io/goose/"
  url "https://github.com/aardappel/goose/archive/refs/tags/v2026.3.tar.gz"
  sha256 "73ef9aeced4a4a3d93dbb3cb0b65a9a1ec3c0efa6c3d4fa4298211919023a5a4"
  license "Apache-2.0"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                   "-DCMAKE_BUILD_TYPE=Release",
                   "-DGOOSE_BUILTIN_LIBS=all",
                   *std_cmake_args

    system "cmake", "--build", "build", "--config", "Release", "--parallel"
    bin.install "build/goose"
  end

  test do
    assert_match "goose", shell_output("#{bin}/goose version")
  end
end
