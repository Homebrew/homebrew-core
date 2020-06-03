class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.13.2.tar.gz"
  sha256 "c94e13d58d3e1cc68168fd177d673662a76bb7fde88e9b9b8cebfd9af5db0089"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a57098525bbbe6bd5683c036ef22acc7cdfc7b2872d9967db3d1b00eaa37b6e" => :catalina
    sha256 "5173e9c565877fcd8510d8e34e7b7052dbe9742c99d29f8af05fcd9ac58a55aa" => :mojave
    sha256 "10bf240238a6d7032690633fdc208a5a97378580dc8ffe865061cd0fd61d2fa6" => :high_sierra
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
