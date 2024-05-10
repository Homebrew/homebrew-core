class Chakra < Formula
  desc "Core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/chakra-core/ChakraCore"
  license "MIT"
  revision 7
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
    sha256 cellar: :any,                 sonoma:       "f39b6f95009d65bd7cc461518c1667856471393d6c1260f99daa2ae667b53194"
    sha256 cellar: :any,                 ventura:      "c4db98f4364992cf9986fa29fa7d33dfa20c8e3ddc9cde9240958d7cfbf69626"
    sha256 cellar: :any,                 monterey:     "60e90a2fe6f156a7653e0a399b786fd8dbec2614dd42dd639fe735a608331503"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "21fa51d8801cdb1e3982bc85d2e02370faa1eb78320bf01e40937295516e81a8"
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

    # Use ld_classic to work around 'ld: Assertion failed: (0 && "lto symbol should not be in layout")'
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

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
