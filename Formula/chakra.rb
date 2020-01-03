class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.15.tar.gz"
  sha256 "8a065b653b8170c2295a48cce226708a2c8357c8d468e076b917eecddae1732d"

  bottle do
    cellar :any
    sha256 "a31f2ec0d7394a2faf7634ce6173df13a081f0927c126564c13e56cde8c6759f" => :mojave
    sha256 "ef89ad378b0561ffe8ed919f94ce0d887fa0ef8afe8c76730430a2a6f7800dc6" => :high_sierra
    sha256 "2473383f68da532b43dd94ca9d37471cdd1f2e69cf20dd58314ad3729f4f8844" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  patch do
    url "https://github.com/microsoft/ChakraCore/commit/4874bbcf.diff?full_index=1"
    sha256 "668d848352a6cbfebccfe4aa3bfa5c4d0a33f90c86e81fc7c4cfbdd57c23524a"
  end

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
