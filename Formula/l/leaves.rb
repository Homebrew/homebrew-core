class Leaves < Formula
  desc "Text-mode disk usage visualization utility"
  homepage "https://github.com/patonw/leaves"
  url "https://github.com/patonw/leaves/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e7635268ddfeddadb2d29ec4f7af22599a5ce6a006082d1621d4de32fd93496b"
  license "MPL-2.0"
  head "https://github.com/patonw/leaves.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e087447950e226b19bfffea60b8ea976a537db6aae81c9bead79a9cc1c3ddacb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc96d24b74345c2b52a20c0ec4828bf70a1add924b6da549b3218e258ede623e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38019064810199bc32ce6087b4cac10aa0a1706052fb2bce47da937a97ff9015"
    sha256 cellar: :any_skip_relocation, sonoma:        "d46d83a2ba408cf53d8405d33f5005255e49444fc6802dc5ce6d8ab1b2936ec5"
    sha256 cellar: :any,                 arm64_linux:   "2c415d24ca8815bdb450d4fe2aa15e2ad0ef1ce25a3e717f34226caa91114933"
    sha256 cellar: :any,                 x86_64_linux:  "d0217c77384d61b6a0766b20201d62126b1583f93d0b9e379b60bd36193c4173"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # leaves is a TUI application
    assert_match version.to_s, shell_output("#{bin}/leaves --version")
  end
end
