class Mutanus < Formula
  desc "Performs mutation testing of you Swift project"
  homepage "https://github.com/SoriUR/mutanus/"
  url "https://github.com/SoriUR/mutanus/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "a534071a0f6f234cd3dc412afab6e825d54181fd8de0a8cc2a3478f1ba2189a8"
  license "MIT"

  depends_on xcode: [">= 12.5", :build]
  depends_on macos: :catalina

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/mutanus"
  end

  test do
    system "#{bin}/mutanus", "--help"
  end
end
