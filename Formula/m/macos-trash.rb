class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "daa545407550ecc46e5088669d1e9eae41219d29ff83d46f46c658bad1c00f85"
  license "MIT"
  head "https://github.com/sindresorhus/macos-trash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d468f853e65b8c0862c13980eb7f4c5b3d3b0bd14b634b9a73d34dc470389bb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb8c8488686d0c2598a216d567d47f19b59be24cb8ce464537225b5130f3f091"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ad2cf3a4a15dd7160bd7054ca15fd8496d56b37e5c12830bbfac49ad27f7299"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c444c294f9a34a566a6f651d1d33f6f17040e18209da2462ee808c5c47c6b8f"
  end

  keg_only :shadowed_by_macos

  depends_on xcode: ["16.0", :build]
  depends_on :macos
  uses_from_macos "swift", since: :sonoma # Swift 6.0

  conflicts_with "osx-trash", because: "both install a `trash` binary"
  conflicts_with "trash-cli", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/trash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trash --version")
    system bin/"trash", "--help"
  end
end
