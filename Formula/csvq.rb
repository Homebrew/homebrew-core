class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.13.7.tar.gz"
  sha256 "f9bb82f5001cb0cc49f5d4684b41d5dc6015f46642f1f695d2b6fd001bf9b62e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f5f451ba7b312c6d2704bc0382ee68d1d4fad99bb66b60e259f12d08030db39c" => :big_sur
    sha256 "c9d23693d5ec4c0d3fd72026c9e259e3573b1455f0607c2a6485c314bdb81bca" => :catalina
    sha256 "139c740da37622049d61776699169a4bc4dfcff1307a77e5b6e73d6d4147a8a2" => :mojave
    sha256 "7969f5aa2a81a65274fcb1da666e1933385bf7ab6bfe996dd04693c4278b787f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/csvq", "--version"

    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    expected = <<~EOS
      a,b
      1,2
    EOS
    result = shell_output("#{bin}/csvq --format csv 'SELECT a, b FROM `test.csv`'")
    assert_equal expected, result
  end
end
