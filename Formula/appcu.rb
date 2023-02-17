class Appcu < Formula
  desc "一款用于对 macOS 上应用进行检查更新的 CLI 工具"
  homepage "https://github.com/ChengLuffy/application_check_update"
  url "https://github.com/ChengLuffy/application_check_update/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "8b6eeccd3de87c4d69d5183293d4ca8e82936f7856a0d9b91fccada42db0c953"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["HOME"] = testpath
    system bin/"appcu", "generate_config"
    assert_predicate testpath/".config/appcu/config.yaml", :exist?
  end
end
