class Diskus < Formula
  desc "Minimal, fast alternative to 'du -sh'"
  homepage "https://github.com/sharkdp/diskus"
  url "https://github.com/sharkdp/diskus/archive/v0.6.0.tar.gz"
  sha256 "661687edefa3218833677660a38ccd4e2a3c45c4a66055c5bfa4667358b97500"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3c4f0aafa14c810b36b2d5dbeb6998bdc866aad7b531f12f14508ee2e8b1c46d" => :catalina
    sha256 "16deb101df03efdcc20f56ed24d2e9608e8733e3bf9f552935ccc73428ac96a3" => :mojave
    sha256 "e603cd7daf7d48e0f139b584ef77f4f59949470e4e2d0ee0f430ac229fe444ea" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.txt").write("Hello World")
    output = shell_output("#{bin}/diskus #{testpath}/test.txt")
    assert_match /4096/, output
  end
end
