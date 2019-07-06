class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.11.5.tar.gz"
  sha256 "6aa213d65c8bf8503f44711e8ea3c02f7500bcc14d6006dc89dcc602e4855906"

  bottle do
    cellar :any_skip_relocation
    sha256 "292deba5ee3673dc8cfbbd417e46b5bf928f55d14eb3f308021298b71fb7cab7" => :mojave
    sha256 "e95262c8361a9aef8f5dec67e2509af4ebe8fc2ee4bb3cf900e706a63d94f266" => :high_sierra
    sha256 "623f76dd524ab045d2e1582e6bcc6d41d9b18e06ec81f3fb1ddca255fac3eb46" => :sierra
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
