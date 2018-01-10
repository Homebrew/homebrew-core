class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.7.6.tar.gz"
  sha256 "545b60fd2ab2aae537c3582a13c40d105663b9a23de49ebcfdfa98e042fee87f"

  bottle do
    cellar :any
    sha256 "9d24cb3d9fd6ee15205a336065ee82255cac862782639bb118bad35415864ade" => :high_sierra
    sha256 "cb2e9842c9715aa937a8eced026c493d621d95f19901a6a36373912c671de9b6" => :sierra
    sha256 "8b64feb5dbadaf19370963fe3e10b5e04186b32ed57e636d5e47c2a0188c4043" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  def install
    system "./build.sh", "--lto-thin", "--static", "--icu=#{Formula["icu4c"].opt_include}", "-j=#{ENV.make_jobs}", "-y"
    bin.install "out/Release/ch" => "chakra"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
