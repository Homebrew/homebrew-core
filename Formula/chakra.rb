class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.11.tar.gz"
  sha256 "afaaf442942eaf568b10e2344eb93ab61bc17169bc6c8e9e8afb44d8d63f6245"

  bottle do
    cellar :any
    sha256 "66dde4dd0794a2fefbf3e625af5ac6ef1b13eca5cfb70e19b5917673d4c33799" => :mojave
    sha256 "d5e0084b59ad3ebda6f6af78d3dab1a80937060be8a9f44e08f5a42af4503074" => :high_sierra
    sha256 "e5d67c34beaba88116995356a0516b797ac1b08b5ad612bed3502834805e42b3" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  def install
    args = [
      "--lto-thin",
      "--icu=#{Formula["icu4c"].opt_include}",
      "--extra-defines=U_USING_ICU_NAMESPACE=1", # icu4c 61.1 compatability
      "-j=#{ENV.make_jobs}",
      "-y",
    ]

    # Build dynamically for the shared library
    system "./build.sh", *args
    # Then statically to get a usable binary
    system "./build.sh", "--static", *args

    bin.install "out/Release/ch" => "chakra"
    include.install Dir["out/Release/include/*"]
    lib.install "out/Release/libChakraCore.dylib"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
