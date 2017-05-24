class Chakra < Formula
  desc "The core part of the Chakra JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.4.4.tar.gz"
  sha256 "448cf905fec91bd6b1b04c7c849f6b6f488d65f49c7943a6a9db9a136aac6f32"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdd4e4dd04846af48290e70ab3cc12ec5d268e2443e2e2008c88f388fba14c22" => :sierra
    sha256 "05da27ee145e09cbd81c7c24e15fba44fd469c14139778402aa5ba7fe4752c9e" => :el_capitan
    sha256 "e1446136769d178a0be96743024ae6d8b22f49b7caa8499a9f7a1be6350b45fb" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "icu4c" => :optional

  def install
    # Build fails with -Os default
    # Upstream issue from 26 Jan 2016 https://github.com/Microsoft/ChakraCore/issues/2417
    # Fixed in master https://github.com/obastemur/ChakraCore/commit/cda81f4
    ENV.O3

    args = ["--static"]
    if build.with? "icu4c"
      args << "--icu=#{Formula["icu4c"].opt_include}"
    else
      args << "--no-icu"
    end
    system "./build.sh", *args

    bin.install "BuildLinux/Release/ch" => "chakra"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
