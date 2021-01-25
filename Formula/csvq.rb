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
    sha256 "559d7e9e16836d219f7abcee7930d139e954bdecee52761384a1d3eea89cc4f7" => :big_sur
    sha256 "15aaff1b59684db446014b7182dedb9e60bfb369eaa714be2741e9bc161cbdfc" => :arm64_big_sur
    sha256 "62a73394c328fa11c7ac9d0f32d5a9b1b5f8ab3443406d3dd47dbe6f3b255bed" => :catalina
    sha256 "9898bd399d0d65bffda8c2358aef85a8ac15941dfe35e95315a15fa39e91506e" => :mojave
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
