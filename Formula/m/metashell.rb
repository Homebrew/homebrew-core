class Metashell < Formula
  desc "Metaprogramming shell for C++ templates"
  homepage "http://metashell.org"
  url "https://github.com/metashell/metashell/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "028e37be072ec4e85d18ead234a208d07225cf335c0bb1c98d4d4c3e30c71f0e"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9de8b8eddbb354a0ed45d39d24e06cee5f05b57a0810155817a7362f45df635a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "842e31ef53f8bd669b6e7344f028ab4de0255a77a593635b9720a451d2e2d47d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4533ad286ccc480236aebbfd1f16b0dd2db015b5c3ffd154c3747e2a25096bac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2958abbe2881a59769b0638d4418acd8d3d5ebd3ab909221f72df4c1354eaf57"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fca9954509cf6db5673c609974da67a844b2bc0f8b51b4acbc39a99ecea42da"
    sha256 cellar: :any_skip_relocation, ventura:        "99787eaf229f32b79c509af891747afa30315dd4e8530a4d298f0bc438c051ce"
    sha256 cellar: :any_skip_relocation, monterey:       "3e8541db362af85b6564cf836accecb73ec8d529d586d52adbae3fe7e5cc88b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd4c0e36370c2b809c525c309f22e0bc849bb0bc8cc92e5d1dfe34f29e9e9ddd"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  # include missing cstddef, upstream PR ref, https://github.com/metashell/metashell/pull/303
  patch do
    url "https://github.com/metashell/metashell/commit/0d81415616d33e39ff6d1add91e71f9789ea8657.patch?full_index=1"
    sha256 "31472db5ae8e67483319dcbe104d5c7a533031f9845af2ddf5147f3caabf3ac2"
  end

  def install
    # Build internal Clang
    system "cmake", "-S", "3rd/templight/llvm",
                    "-B", "build/templight",
                    "-DLIBCLANG_BUILD_STATIC=ON",
                    "-DLLVM_ENABLE_TERMINFO=OFF",
                    "-DLLVM_ENABLE_PROJECTS=clang",
                    *std_cmake_args
    system "cmake", "--build", "build/templight", "--target", "templight"

    system "cmake", "-S", ".", "-B", "build/metashell", *std_cmake_args
    system "cmake", "--build", "build/metashell"
    system "cmake", "--install", "build/metashell"
  end

  test do
    (testpath/"test.hpp").write <<~EOS
      template <class T> struct add_const { using type = const T; };
      add_const<int>::type
    EOS
    output = pipe_output("#{bin}/metashell -H", (testpath/"test.hpp").read)
    assert_match "const int", output
  end
end
