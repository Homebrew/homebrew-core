class Chakra < Formula
  desc "Core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/chakra-core/ChakraCore"
  license "MIT"
  revision 9
  head "https://github.com/chakra-core/ChakraCore.git", branch: "master"

  stable do
    url "https://github.com/chakra-core/ChakraCore/archive/refs/tags/v1.11.24.tar.gz"
    sha256 "b99e85f2d0fa24f2b6ccf9a6d2723f3eecfe986a9d2c4d34fa1fd0d015d0595e"

    depends_on arch: :x86_64 # https://github.com/chakra-core/ChakraCore/issues/6860

    # Fix build with modern compilers.
    # Remove with 1.12.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/chakra/clang10.patch"
      sha256 "5337b8d5de2e9b58f6908645d9e1deb8364d426628c415e0e37aa3288fae3de7"
    end

    # Support Python 3.
    # Remove with 1.12.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/chakra/python3.patch"
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
    sha256 cellar: :any,                 sonoma:       "7b16aa6c8b2677f2dba55987d78f4cc867d357aeba2b6b3d97e76e42c6c69c4b"
    sha256 cellar: :any,                 ventura:      "dc7589f199baf02f63525cd1b5adb4e971d87b9c2369eb3e031dd4234acefac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cb090973883ca8832598f8d020bb6c3454567a7a1dd8537325a636be45fb0300"
  end

  # Can be considered for un-deprecation if upstream does a new release
  deprecate! date: "2025-03-28", because: "fails to run on Linux after rebuild and last release was 2020-12-08"

  depends_on "cmake" => :build
  depends_on "icu4c@76"

  uses_from_macos "llvm" => :build
  uses_from_macos "python" => :build

  fails_with :gcc do
    cause "requires Clang, see https://github.com/chakra-core/ChakraCore/issues/2038"
  end

  def install
    # Use ld_classic to work around 'ld: Assertion failed: (0 && "lto symbol should not be in layout")'
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500
    # Workaround to build with ICU 76+
    ENV.append_to_cflags "-DU_SHOW_CPLUSPLUS_HEADER_API=0"

    icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
    args = %W[
      --custom-icu=#{icu4c_dep.to_formula.opt_include}
      --jobs=#{ENV.make_jobs}
      -y
    ]
    # LTO requires ld.gold, but Chakra has no way to specify to use that over regular ld.
    args << "--lto-thin" if OS.mac? && !Hardware::CPU.arm?
    # JIT is not supported on ARM and build fails since Xcode 16
    args << "--no-jit" if Hardware::CPU.arm? || DevelopmentTools.clang_build_version >= 1600

    system "./build.sh", *args

    libexec.install "out/Release/ch" => "chakra"
    include.install Dir["out/Release/include/*"]
    lib.install "out/Release/#{shared_library("libChakraCore")}"

    # Non-statically built chakra expects libChakraCore to be in the same directory
    bin.install_symlink libexec/"chakra"
    libexec.install_symlink lib.children
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
