class OsxTrash < Formula
  desc "Allows trashing of files instead of tempting fate with rm"
  homepage "https://github.com/morgant/tools-osx#trash"
  url "https://github.com/morgant/tools-osx/archive/refs/tags/trash-0.7.1.tar.gz"
  sha256 "9ac54a5eb87c4c6a71568256c0e29094a913f2adf538fb2c504f6c8b1f63be12"
  license "MIT"
  head "https://github.com/morgant/tools-osx.git", branch: "master"

  livecheck do
    url :stable
    regex(/^trash[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on :macos

  def install
    bin.install "src/trash"
  end

  test do
    assert_match(/across \d+ volume/, shell_output("#{bin}/trash --list"))
  end
end
