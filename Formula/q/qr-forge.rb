class QrForge < Formula
  desc "Professional QR code generator built with Rust"
  homepage "https://github.com/fra2404/qr-forge"
  url "https://github.com/fra2404/qr-forge/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "51ee65125930a7fc533e04c84a1442f1fd70a7f5bdecd39dde96ea6e591da941"
  license "MIT"
  head "https://github.com/fra2404/qr-forge.git", branch: "main"

  depends_on "rust" => :build

  on_linux do
    depends_on "gcc" => :build
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "qr-forge", shell_output("#{bin}/qr-forge --version")
    system bin/"qr-forge", "--url", "https://example.com", "--output", "test", "--format", "png"
    assert_path_exists testpath/"test.png"
  end
end
