class Chakra < Formula
  desc "Core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/chakra-core/ChakraCore"
  license "MIT"
  revision 6
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
  end

  bottle do
    sha256 cellar: :any,                 ventura:      "f7b87e1a5e8df971a1a70d83cce648a0c8099d9353859035896c882323af0a4b"
    sha256 cellar: :any,                 monterey:     "26401fbd6570cfd5e5581a707f61cacbc917674dd3d35d7ae48418c20e852580"
    sha256 cellar: :any,                 big_sur:      "09e445d4df2da3d80e3245bebb269b4f893fab9e600fd08653c065fe313ead0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a1033b83b4ba7b914ab67d205e83bc70600d7585a958d0fb4e1ff438d058dee1"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  uses_from_macos "python" => :build

  on_linux do
    # Currently requires Clang, but fails with LLVM 16.
    depends_on "llvm@15" => :build
  end

  def install
    ENV.clang if OS.linux? # Currently fails to build with LLVM 16.

    args = %W[
      --custom-icu=#{Formula["icu4c"].opt_include}
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
