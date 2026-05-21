class Nvi2 < Formula
  desc "Multibyte fork of the nvi editor for BSD"
  homepage "https://github.com/lichray/nvi2"
  url "https://github.com/lichray/nvi2/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "a1ad5d7c880913992a116cba56e28ee8e7d1f59a7f10e5a9b2ce6d105decb59c"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # It won't actually build on Linux because it relies on Berkeley
  # DB 1.x features not provided by libdb1-compat.
  uses_from_macos "libiconv"

  conflicts_with "nvi", because: "nvi2 also provides a binary named nvi"

  def install
    system "cmake", "-G", "Ninja Multi-Config", "-B", "build"
    system "ninja", "-C", "build", "-f", "build-Release.ninja"

    File.rename("man/vi.1", "man/nvi.1")
    man1.install "man/nvi.1"
    bin.install "build/Release/nvi"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/nvi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
