class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/v1.1.1.tar.gz"
  sha256 "e215bda0c485c89a893b5ad8f4087b99b78b3616f26f0c8da3f0bb09022136dc"
  license "MIT"
  head "https://github.com/sindresorhus/macos-trash.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "049e44820f9e1477adb355c009528157e3489c398729a0a5a40809061ebd365a" => :big_sur
    sha256 "def2ebfb6f6dfd00122d680cfa770a59d495eb4dec459a8ed9160c20286df732" => :arm64_big_sur
    sha256 "420db6ae6caa28451dff5a1e1469f33ac07059ff82221274fbe8dbcbe690bb60" => :catalina
  end

  depends_on xcode: ["12.0", :build]

  conflicts_with "trash", because: "both install a `trash` binary"
  conflicts_with "trash-cli", because: "both install a `trash` binary"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/trash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trash --version")
    system "#{bin}/trash", "--help"
  end
end
