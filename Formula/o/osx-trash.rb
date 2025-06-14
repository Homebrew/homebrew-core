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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ff2a7e4c4d9e83a5cf38815cbbae8407295d8c830d85211677d6041add46bfa"
  end

  keg_only :shadowed_by_macos

  depends_on :macos

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash-cli", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  def install
    bin.install "src/trash"
  end

  test do
    # Direct execution would trigger accessibility permissions, failing CI.
    assert_match "v#{version}", shell_output("strings #{bin}/trash")
  end
end
