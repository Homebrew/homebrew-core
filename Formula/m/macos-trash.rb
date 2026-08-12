class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "40c460b37d18544444691f3f086495d20a4d11a933656c8e2a4af685d5050313"
  license "MIT"
  head "https://github.com/sindresorhus/macos-trash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "527fe913d039d21ebeb41ce0229ef539d1a5f6b74a5aa5b74237cb31d45a1af6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f7b441ad551b252c7a9234af6ab721d67ea78b554688603b560b7a66aee262f"
    sha256 cellar: :any,                 arm64_sonoma:  "714ef503cf86dcca310b5d955532f7f73b3afe08458d66a4a71bf522af9c8020"
    sha256 cellar: :any,                 sonoma:        "530b366b09c327a1948838e8b0bff9114194621f0d756a473925439f498d5ac5"
  end

  keg_only :shadowed_by_macos

  depends_on macos: :ventura
  uses_from_macos "swift" => :build, since: :sequoia # swift 6.2+

  conflicts_with "osx-trash", because: "both install a `trash` binary"
  conflicts_with "trash-cli", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/trash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trash --version")
    system bin/"trash", "--help"
  end
end
