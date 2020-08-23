class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-2.8.5.tar.gz"
  sha256 "0f757c64a8342fe38ec501bde68b61d26d051dffd45742ca58b7288a99c7e2d8"
  license "GPL-3.0"

  bottle do
    sha256 "046ba5e9ec0d0856557085fdf1acde227cd829d9955da28046e98c9a5ee84c09" => :catalina
    sha256 "7e1acd53615ebc407aaae64eb23af6047dbbd42f967e422b3fcfa0c6d01307b6" => :mojave
    sha256 "18013401e3eed914022e0a34c6b9b1ed415ec679113de78970d74aa52b0a35e8" => :high_sierra
  end

  on_linux do
    depends_on "postgresql"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
