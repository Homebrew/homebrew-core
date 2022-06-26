class Chakra < Formula
  desc "Core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/chakra-core/ChakraCore"
  url "https://github.com/chakra-core/ChakraCore/archive/v1.11.24.tar.gz"
  sha256 "b99e85f2d0fa24f2b6ccf9a6d2723f3eecfe986a9d2c4d34fa1fd0d015d0595e"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 monterey:     "ec25aaa2de73e2ba9c7977481ef2e79c01abe907ac59d156cccafc3366082742"
    sha256 cellar: :any,                 big_sur:      "306cae3a82ea3a543d2881ae60be87ca57ec28aaa3e7faecf9348f28f38ac7bb"
    sha256 cellar: :any,                 catalina:     "463875e46c4ed92c504a97ecbcb90381942b089d76cfbdba92a3e9495090e66b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a48748d8f53394c96d7168e7b9c2f065f5ae8e0c4694784b9839596e71490172"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "icu4c"

  uses_from_macos "llvm" => [:build, :test]

  # Currently requires Clang.
  fails_with :gcc

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

  def install
    args = %W[
      --icu=#{Formula["icu4c"].opt_include}
      -j=#{ENV.make_jobs}
      -y
    ]
    # LTO requires ld.gold, but Chakra has no way to specify to use that over regular ld.
    args << "--lto-thin" if OS.mac?

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
