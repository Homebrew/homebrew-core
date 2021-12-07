class Mutanus < Formula
  desc "Performs mutation testing of you Swift project"
  homepage "https://github.com/SoriUR/mutanus/"
  url "https://github.com/SoriUR/mutanus/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "ec5f663a76166c18ee3a76e3fd69bfd1b29526dc567c3994e9a119624b992e34"
  license "MIT"

  depends_on xcode: ["12.5", :build]
  depends_on macos: :catalina

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/mutanus"
  end

  test do
    system "#{bin}/mutanus", "config"
    assert_predicate testpath/"MutanusConfig.json", :exist?
  end
end
