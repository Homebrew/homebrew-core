class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/20200701.154658.b0d6223.tar.gz"
  version "20200701.154658.b0d6223"
  sha256 "52f11dc0cbd8964fcdaf019bfada2102f9ee716a1d480cd43ae5925b4361c834"
  license "GPL-2.0"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git"

  bottle do
    cellar :any_skip_relocation
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
