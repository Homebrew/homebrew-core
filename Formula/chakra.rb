class Chakra < Formula
  desc "The core part of the Chakra JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.4.0.tar.gz"
  sha256 "f6b4a3bce9e69bb3ea619a82805460906ef53d4f9da98b51e554dd48d6cdfdb3"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0fef46cf4705b69a52678c0baba358da73a7d989669c5102c3167510945e0cd" => :sierra
    sha256 "3402242c5abfbe83615eb06b0d1eac27ee49b9bd6f4f77218c3b402c5f44a384" => :el_capitan
    sha256 "266a7f78b91f0e5963d22b9dc19c427f8680cae97d19eb79a4077a300f194fbf" => :yosemite
  end

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
