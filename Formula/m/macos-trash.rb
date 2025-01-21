class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "c4472b5c8024806720779bc867da1958fe871fbd93d200af8a2cc4ad1941be28"
  license "MIT"
  head "https://github.com/sindresorhus/macos-trash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "291cf5358523a9a84842f779f09d36f7dccfe4c5f1cf6b5146b13e3098c4e3e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34f68f4aaee66e7a5db78072b47c51b9926b11b03b4fad43a71338f5db9e06b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14d22be61e2e75a7592b42234d0e62696340551aef10bb53d1996bd7e6af649d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cff573086ce20b6b3c1ace838570390605cd758965e455c1b36b097b3130ccb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "557c7c851c37f3cc90607e0565ee96e01f346ea675dcd2d894d5949471c90375"
    sha256 cellar: :any_skip_relocation, sonoma:         "3338a9e0978aa7763eeaacc726a284754ee3ec0120b40cad11b2a9013ccfe859"
    sha256 cellar: :any_skip_relocation, ventura:        "f9e177eaa76b291ca8aab09866bcf8ad323fabc12f2c9ceeece59131cd3b67a3"
    sha256 cellar: :any_skip_relocation, monterey:       "14e572ed0ed3b36e475357e7fe67b2a575da6f17b190350c9aec51fb08f45e7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "42e5185162cd75cb1e660beacfff18fa404dc98dcb5c5249d117c8dfe5fa6a53"
    sha256 cellar: :any,                 catalina:       "bee0b6a9d5e1f9b23a9513a58d89b924ab3343613e94a62846eed2f9df8108d4"
  end

  keg_only :shadowed_by_macos

  depends_on xcode: ["12.0", :build]
  depends_on :macos
  uses_from_macos "swift", since: :big_sur # Swift 5.5.0

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/trash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trash --version")
    system bin/"trash", "--help"
  end
end
