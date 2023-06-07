class Lci < Formula
  desc "Interpreter for the lambda calculus"
  homepage "https://www.chatzi.org/lci/"
  url "https://github.com/chatziko/lci/releases/download/v1.0/lci-1.0.tar.gz"
  sha256 "1bcf40d738ce2af7ca5116f02dfb0f4ed21d7e467e3618e071c8199a1285331e"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_ventura:  "21afc33909d59c974988a19f1189c56451430b0ff1bd687d421fbcb227e3c215"
    sha256                               arm64_monterey: "7fb1ab319d3340b759042f184cd043f50f3897bf8f0650885fe8b679b630c52c"
    sha256                               arm64_big_sur:  "6540439b0f6ea5653aab7ac697f708bf3effa3135f2b8a8d2d98a08e137fab15"
    sha256                               ventura:        "4dd1911200ea6dda6223506317afea28ef0d54271b61922f6d18b87211b0e68a"
    sha256                               monterey:       "3f433ee3ec85efa51ac6faab75a0570ed673c5ee0ec36598fa968e2525989d78"
    sha256                               big_sur:        "f531babdee7254e6bcf5a04f44e388d7b398925d7b9529f0a6fba11e3dae4ced"
    sha256                               catalina:       "a55400bf771e5c89f5357fc9847929c0bac34e0164ed306b6ea9f3be3a700ebc"
    sha256                               mojave:         "a1c26ba18c1080a20edc4baf966c579aab841ca73d8f81760df7ca0b32830e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca80c45e5eca084c3ec55f3d7a0d140f94ae8cf3e5277341875bbac99186ef0e"
  end

  depends_on "cmake" => :build

  conflicts_with "lolcode", because: "both install `lci` binaries"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "[I, 2]", pipe_output("#{bin}/lci", "Append [1] [2]\n")
  end
end
