class Chakra < Formula
  desc "The core part of the Chakra JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.4.0.tar.gz"
  sha256 "f6b4a3bce9e69bb3ea619a82805460906ef53d4f9da98b51e554dd48d6cdfdb3"

  depends_on "cmake" => :build
  depends_on "icu4c" => :optional

  # Remove for > 1.4.0
  # Fix build failure on case-sensitive file systems
  # https://github.com/Microsoft/ChakraCore/pull/2421
  patch do
    url "https://github.com/Microsoft/ChakraCore/commit/bb5c393.patch"
    sha256 "5694f260c910d11c59211766592002c27b3c1ecbb0c712f84e32c115d44666ed"
  end

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
