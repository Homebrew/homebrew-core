class Chakra < Formula
  desc "The core part of the Chakra JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.4.3.tar.gz"
  sha256 "b0f6d626f3c895428947d5b67e90e5965c032e21689dc8d6c326a697e859980b"

  bottle do
    cellar :any_skip_relocation
    sha256 "6dd73487b7fe3486c5162fa6cb0475472c5edaf04b43e50fcc539ad62cad9db3" => :sierra
    sha256 "9f8ee94c2044f43e06e507da197f3f7968563b71a9c5cd8b8e6b52c62dfa9f9e" => :el_capitan
    sha256 "b577dbf946cc30b1156b77157034ff386c3f4bd45f1cbdf2e927626ec807c10b" => :yosemite
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
