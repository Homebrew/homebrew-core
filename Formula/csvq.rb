class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.11.7.tar.gz"
  sha256 "684e864c3dea0c6620b7764ef9e737b85215ffc22214aa4abbd96217ea383b0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3695aca3750d43b55e34bf5104928053a1723e8826d3437c79bcd1c89bf4507" => :catalina
    sha256 "fad9089f3112a11feff1c525a965af98d0336ec63bd4c33b3956fbbbf3c3786e" => :mojave
    sha256 "776c35f8d30a8e4f48aac93cb02a5ae837875f7c0d0dadcc023ed32c7c978ecf" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "csvq"
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
