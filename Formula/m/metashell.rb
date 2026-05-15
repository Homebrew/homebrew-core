class Metashell < Formula
  desc "Metaprogramming shell for C++ templates"
  homepage "http://metashell.org"
  url "https://github.com/metashell/metashell/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "028e37be072ec4e85d18ead234a208d07225cf335c0bb1c98d4d4c3e30c71f0e"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "31ffe3eacbb6ebd7186612d278f5df4fac34eb2d5efe844e7413ada10a59ce3c"
    sha256 cellar: :any,                 arm64_sequoia: "aec2935132e0d2d67702b10cab3b2e362c3dcd8ad82a27296d71999d1c1e5e24"
    sha256 cellar: :any,                 arm64_sonoma:  "eb81c0aeccad45137a84692e5190c7ec08d7f08263671ccc0edfd404d3547309"
    sha256 cellar: :any,                 sonoma:        "2108b65d96f0b6ee0eca068bf5880c7a9e3acdcd341dfb7f3d68fceb7d09cbc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2109f64273ef097d9a3ea8e1eea326dada552053facdee5075f03f38d418ef8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559e19b799f8f41040ba4a770086dccc2dbbb69f72093bf0839fff94066a274b"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "libedit"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  # include missing cstddef, upstream PR ref, https://github.com/metashell/metashell/pull/303
  patch do
    url "https://github.com/metashell/metashell/commit/0d81415616d33e39ff6d1add91e71f9789ea8657.patch?full_index=1"
    sha256 "31472db5ae8e67483319dcbe104d5c7a533031f9845af2ddf5147f3caabf3ac2"
  end

  # fix build with cmake 4, upstream PR ref, https://github.com/metashell/metashell/pull/306
  patch do
    url "https://github.com/metashell/metashell/commit/38b524ae291799a7ea9077745d3fc10ef2d40d54.patch?full_index=1"
    sha256 "e97590ca1d2b5510dcfcca86aa608e828040bb91519f6b161f7b4311676f4fd4"
  end

  def install
    # remove -msse4.1 if unsupported, issue ref: https://github.com/metashell/metashell/issues/305
    inreplace "3rd/boost/atomic/CMakeLists.txt", /\btarget_compile_options.*-msse4/, "#\\0" if Hardware::CPU.arm?

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
    (testpath/"test.hpp").write <<~CPP
      template <class T> struct add_const { using type = const T; };
      add_const<int>::type
    CPP
    output = pipe_output("#{bin}/metashell -H", (testpath/"test.hpp").read)
    assert_match "const int", output
  end
end
