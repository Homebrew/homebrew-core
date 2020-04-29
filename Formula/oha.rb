class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/0.2.4.tar.gz"
  sha256 "ebb1964747da49b5360a908fd527f2f018c7cd153fd19dd8c8cd0d00ad816c4d"

  bottle do
    cellar :any_skip_relocation
    sha256 "85a0f4985360b43b39463a14095092fb59e7301c9f6e9c2c2a3016f59e88ebe0" => :catalina
    sha256 "7d75f4966c217216899834adc162cd4820c457ba211402c2f97100c1040d368f" => :mojave
    sha256 "3c06fe21b4b14862896a1648d05145275a79cb62ce7a4716b634262c85aefcc2" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
