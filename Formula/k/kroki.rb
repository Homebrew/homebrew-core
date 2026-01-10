class Kroki < Formula
  desc "Create diagrams from textual descriptions"
  homepage "https://kroki.io"
  url "https://github.com/yuzutech/kroki-cli/releases/download/v0.5.0/kroki-cli_0.5.0_darwin_amd64.tar.gz"
  sha256 "d7d6f3c300cd34fe654bf3dfdce225b2a1a861f57301c25de711a9687fc5205f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # Only x86_64 binary is provided for macOS
  depends_on arch: :x86_64

  def install
    bin.install "kroki"
  end

  test do
    system bin/"kroki", "version"
  end
end
