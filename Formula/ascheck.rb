class Ascheck < Formula
  desc "Command-line app that checks all of your apps for their Apple Silicon support"
  homepage "https://github.com/harryzcy/ascheck"
  url "https://github.com/harryzcy/ascheck/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5a90fa2b521ca68fced0866a8055c36fb7367a37bd8d04ac5e3ad391b6706fa4"
  license "MIT"
  head "https://github.com/harryzcy/ascheck.git"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "ascheck"
    bin.install "ascheck"
  end

  test do
    system "#{bin}/ascheck", "--help"
  end
end
