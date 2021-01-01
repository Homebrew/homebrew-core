class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/20201231.092811.cbecfb1.tar.gz"
  version "20201231.092811.cbecfb1"
  sha256 "b38f3483ed07aa556e3faf070630a73035a69e57a182ed4394b1974da7c59f88"
  license "GPL-2.0"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e79d2e76d6fd57bb96cbc879e9760d556284c7c61ecd345edeed73442cbce203" => :big_sur
    sha256 "fef552dd4f9361c20281cc87de2c69aa7cd54a9a0fe07de15c17d9c987acc3ec" => :arm64_big_sur
    sha256 "6bc22e04f5d2863e73010606d823eb0768d637165d190d3889db3780bbbb724c" => :catalina
    sha256 "204e206047f48cdffef4fa91f81dbce6db370f002dd883000798d91f2916c391" => :mojave
    sha256 "ce2509fe2cc72c18b6b82c9df5e802e2503f61ebf841833618a974ac21fc92c3" => :high_sierra
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", ".", "--config", "Release"
    bin.install "AtomicParsley"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"
    system "#{bin}/AtomicParsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/AtomicParsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
