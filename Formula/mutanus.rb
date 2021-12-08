class Mutanus < Formula
  desc "Performs mutation testing of you Swift project"
  homepage "https://github.com/SoriUR/mutanus/"
  url "https://github.com/SoriUR/mutanus/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "f235804fa48e4150bdadf9276ba6380fa224aad1233e273c9dc5e61391803efc"
  license "MIT"

  depends_on xcode: ["12.5", :build]
  depends_on :macos
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
