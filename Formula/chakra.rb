class Chakra < Formula
  desc "The core part of the Chakra JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.4.2.tar.gz"
  sha256 "97756d827de1f15dc1b7b28acbc0c6f7d15f46c7a70f3dce83b1f0c52016d1ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6f92ab77539f0b307dcc94153be7689dfe050f07ce54b706f1f3d3e8c6865d2" => :sierra
    sha256 "50f4f12db16d4b737a1658f73f538935b8725079cba890bf8e942eb1835f6d67" => :el_capitan
    sha256 "e9b2936b97338308eff93d708b58f0d8b2a9ec42aaa22936878265cc6513ac5b" => :yosemite
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
