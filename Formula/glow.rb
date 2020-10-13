class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.0.1.tar.gz"
  sha256 "78d163bea8e6c13fb343f1e3586e93e0392e5052c408a248cc2f0fcc7aa38618"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e74da6ca3d25f57d2dfd56799d8ca109320086eb40fd42d3c904120b4d871bf3" => :catalina
    sha256 "f48a89f443dc2f9649f52dceef74d9bddfb758fa09457e515e1c4b0cfa3fb8d4" => :mojave
    sha256 "876a145c0a6d83547f43c317d05545a02c8781fc10460f7e5c660c33033bc69b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/name
  end

  test do
    (testpath/"test.md").write <<~EOS
      # header

      **bold**

      ```
      code
      ```
    EOS
    assert_match "# header", shell_output("#{bin}/glow test.md")
  end
end
