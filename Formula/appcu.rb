class Appcu < Formula
  desc "一款用于对 macOS 上应用进行检查更新的 CLI 工具"
  homepage "https://github.com/ChengLuffy/application_check_update"
  url "https://github.com/ChengLuffy/application_check_update/releases/download/v0.1.0/appcu.tar.gz"
  sha256 "752ad84867b81c18d9972aa31cc55420b573c5583b90899871f18b60f5da1f80"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"appcu", "generate_config"
  end
end
