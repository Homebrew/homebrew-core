class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.9.2.tar.gz"
  sha256 "50647d42abeea133430cac2d4eb6807ad19d7825996944338df5caaf39e4dc29"

  bottle do
    sha256 "63b3945178d023812388c35dc07ade5595e3f365ced8b838bf7a335c417a7d24" => :high_sierra
    sha256 "fd8d2eed0ef7568041e9dfd3c8c56c2f0bd8d95efd41bca4a20e2b95d8f047e7" => :sierra
    sha256 "b9ac743234b654b8c00a68d378731e932a4006d56a9654a30e5ee807d00830b2" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat #{testpath}/test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
