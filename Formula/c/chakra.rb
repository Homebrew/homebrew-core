class Chakra < Formula
  desc "Core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/chakra-core/ChakraCore"
  license "MIT"
  revision 8
  head "https://github.com/chakra-core/ChakraCore.git", branch: "master"

  stable do
    url "https://github.com/chakra-core/ChakraCore/archive/refs/tags/v1.11.24.tar.gz"
    sha256 "b99e85f2d0fa24f2b6ccf9a6d2723f3eecfe986a9d2c4d34fa1fd0d015d0595e"

    depends_on arch: :x86_64 # https://github.com/chakra-core/ChakraCore/issues/6860

    # Fix build with modern compilers.
    # Remove with 1.12.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/204ce95fb69a2cd523ccb0f392b7cce4f791273a/chakra/clang10.patch"
      sha256 "5337b8d5de2e9b58f6908645d9e1deb8364d426628c415e0e37aa3288fae3de7"
    end

    # Support Python 3.
    # Remove with 1.12.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/308bb29254605f0c207ea4ed67f049fdfe5ec92c/chakra/python3.patch"
      sha256 "61c61c5376bc28ac52ec47e6d4c053eb27c04860aa4ba787a78266840ce57830"
    end

    # Backport fixes needed to build with newer Clang on Linux
    patch do
      url "https://github.com/chakra-core/ChakraCore/commit/a2aae95cfb16cda814c557cc70c4bdb5156fd30f.patch?full_index=1"
      sha256 "07c94241591be4f8c30b5ea68d7fa08e8e71186f26b124ee871eaf17b2590a28"
    end
    patch do
      url "https://github.com/chakra-core/ChakraCore/commit/46af28eb9e01dee240306c03edb5fa736055b5b7.patch?full_index=1"
      sha256 "d59f8bb5bbf716e4971b3a50d5fe2ca84c5901b354981e395a6c37adad8b2bb2"
    end
  end

  bottle do
    sha256 cellar: :any,                 sonoma:       "0312de0964e13f78d77a70f2ce9fb07a551698c2845572797c5bcfee70445a22"
    sha256 cellar: :any,                 ventura:      "eee806adf9099aa00c3680bdb59e3e2cd995e85020d97654a84c668375d463bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "de0544b3bb920d7764b0a51ea1e591512f06791bc1ae18ddea9be6f6b33bf740"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@75"

  uses_from_macos "llvm" => :build
  uses_from_macos "python" => :build

  fails_with :gcc do
    cause "requires Clang, see https://github.com/chakra-core/ChakraCore/issues/2038"
  end

  def install
    # Use ld_classic to work around 'ld: Assertion failed: (0 && "lto symbol should not be in layout")'
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
    args = %W[
      --custom-icu=#{icu4c_dep.to_formula.opt_include}
      --jobs=#{ENV.make_jobs}
      -y
    ]
    # LTO requires ld.gold, but Chakra has no way to specify to use that over regular ld.
    args << "--lto-thin" if OS.mac? && !Hardware::CPU.arm?
    # JIT is not supported on ARM
    args << "--no-jit" if Hardware::CPU.arm?

    # Build dynamically for the shared library
    system "./build.sh", *args
    # Then statically to get a usable binary
    system "./build.sh", "--static", *args

    bin.install "out/Release/ch" => "chakra"
    include.install Dir["out/Release/include/*"]
    lib.install "out/Release/#{shared_library("libChakraCore")}"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
