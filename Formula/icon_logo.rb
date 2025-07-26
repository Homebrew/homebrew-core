class IconLogo < Formula
  desc "图标生成工具"
  homepage "https://github.com/zk3151463/icon_logo"
  url "https://github.com/zk3151463/icon_logo/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "1c9e01edd41b19a99fcd2ab82fcfe681562b0db2e3e878136758f58dc737c0b6"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Usage", shell_output("\#{bin}/icon_logo --help")
  end
end
