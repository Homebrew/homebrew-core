class JsonTable < Formula
  desc "Transform nested JSON data into tabular data in the shell"
  homepage "https://github.com/micha/json-table"
  url "https://github.com/micha/json-table/archive/4.3.3.tar.gz"
  sha256 "0ab7bb2a705ad3399132060b30b32903762473ff79b5a6e6f52f086e507b0911"
  head "https://github.com/micha/json-table.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "61d89ff5426049b2f0fbb237862ec1227cd36c8f00ce81f9a382e8b7d1c2792a" => :catalina
    sha256 "49f7c1f8e757456f63d5e8b9cb7ef0f2b1cdb22303b2ae799595305cb7e65c5b" => :mojave
    sha256 "2afef9b965070bcde986759dbd03cfd8fe3e77aec5a12158fb4aa189626ab977" => :high_sierra
    sha256 "e5ed8ece1e10ede4417f347703f1e62bb417c65a11f6cac5f10915d44359eb5b" => :sierra
    sha256 "3240813838be9e797fd443e5f51d6bb53fc56a8d958dd361cbc865de003619bd" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/jt x y %", '{"x":{"y":[1,2,3]}}', 0)
    assert_equal "3", output.lines.last.chomp
  end
end
