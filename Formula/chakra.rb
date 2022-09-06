class Chakra < Formula
  desc "Core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/chakra-core/ChakraCore"
  url "https://github.com/chakra-core/ChakraCore/archive/v1.11.24.tar.gz"
  sha256 "b99e85f2d0fa24f2b6ccf9a6d2723f3eecfe986a9d2c4d34fa1fd0d015d0595e"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any,                 monterey:     "ceb1e0d100c99107f9ebd5ec897a1f401d7114239a6c8b43a315d93099b67a9e"
    sha256 cellar: :any,                 big_sur:      "77f0293194dd2f7b8cf8fc9f6538223dc732430096ed292ceb8c2e5f046a4abd"
    sha256 cellar: :any,                 catalina:     "b3adc33441dcdaacee5df9f3924bf3d8d2df77a2f71265a01b06eead1d489ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b129d6e652ff6b3d86c025742aefcb3e47bc6d470844ddf6d4d5ce6d011c936e"
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
