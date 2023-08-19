class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/v1.2.0.tar.gz"
  sha256 "c4472b5c8024806720779bc867da1958fe871fbd93d200af8a2cc4ad1941be28"
  license "MIT"
  head "https://github.com/sindresorhus/macos-trash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14d22be61e2e75a7592b42234d0e62696340551aef10bb53d1996bd7e6af649d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cff573086ce20b6b3c1ace838570390605cd758965e455c1b36b097b3130ccb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "557c7c851c37f3cc90607e0565ee96e01f346ea675dcd2d894d5949471c90375"
    sha256 cellar: :any_skip_relocation, ventura:        "f9e177eaa76b291ca8aab09866bcf8ad323fabc12f2c9ceeece59131cd3b67a3"
    sha256 cellar: :any_skip_relocation, monterey:       "14e572ed0ed3b36e475357e7fe67b2a575da6f17b190350c9aec51fb08f45e7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "42e5185162cd75cb1e660beacfff18fa404dc98dcb5c5249d117c8dfe5fa6a53"
    sha256 cellar: :any,                 catalina:       "bee0b6a9d5e1f9b23a9513a58d89b924ab3343613e94a62846eed2f9df8108d4"
  end

  depends_on xcode: ["12.0", :build]
  depends_on :macos
  uses_from_macos "swift", since: :big_sur # Swift 5.5.0

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
