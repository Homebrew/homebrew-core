class Mutanus < Formula
  desc "Performs mutation testing of you Swift project"
  homepage "https://github.com/SoriUR/mutanus/"
  url "https://github.com/SoriUR/mutanus/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "73204fe4b1788c2427d2d12f8a5d2579469cd8910ecfa777974d431118d83155"
  license "MIT"

  depends_on xcode: [">= 12.5", :build]
  depends_on macos: [
    :catalina,
    :big_sur,
  ]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/mutanus"
  end

  test do
    system "#{bin}/mutanus", "--help"
  end
end
