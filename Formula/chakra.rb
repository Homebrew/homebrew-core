class Chakra < Formula
  desc "The core part of the Chakra JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.4.1.tar.gz"
  sha256 "80b3cae99475562dd740c470e4398e0649509eeb31c42dccc09dde19330d83e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0fef46cf4705b69a52678c0baba358da73a7d989669c5102c3167510945e0cd" => :sierra
    sha256 "3402242c5abfbe83615eb06b0d1eac27ee49b9bd6f4f77218c3b402c5f44a384" => :el_capitan
    sha256 "266a7f78b91f0e5963d22b9dc19c427f8680cae97d19eb79a4077a300f194fbf" => :yosemite
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
