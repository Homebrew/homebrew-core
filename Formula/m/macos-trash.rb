class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "87089efd5f47e4281986647c8e6ea8dc10429ba83ae7e7386a91dfccc03bee20"
  license "MIT"
  head "https://github.com/sindresorhus/macos-trash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "837419a21b5c21d63e2de521f028c432ff940bf818b223bb2d0f9a5d88e07cab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61cc960fd152c59ea72b3d359990278d2656ebe2be906a31d3af6a868c608cc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b2426efa574b998d6da53ebaae86471792a483d0542f20d40e68f40ad591424"
    sha256 cellar: :any_skip_relocation, sonoma:        "1616ab084278465dee0c363631477f1954858316a40284fed41a7f6932f2ae0d"
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
