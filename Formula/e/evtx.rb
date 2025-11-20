class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e5f5221879a68b455a086653ab457f815544d1580e591f52d3b0ed5b4b24f328"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c8d03f8dbd914cab8d435ee83474bb77e9f155049f6d681ec5f4ee31afc1a1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bbf48bed0be78aaee845e20b9ffca25cca24994a0bba85a1b26c9e7c295e3fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa8ccb06035b4b5e5876ead4f44adeb3eb301663ad97268a552320a679879216"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50ad5fc49b1cc7eb1a6f1d55e3a4b0ae9a2635eb8bdbd78d68016a69c531c15d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd9762d528f9b57d15b07c0711ae454b0586f0f43b4f359b9d9ac7d07bf55eda"
    sha256 cellar: :any_skip_relocation, ventura:       "4fecfa0eed949e0c12a4b067814231f3594c9f0750c762fe11caeb4e52f512ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78f6aa38281dc73df685038ae3e156ff24bedf40fd8dd65c582d84a58d8d2ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c0ee6a7a20a5136cae808acfa75f22b8013aa294819344a870ad76d83d8b3c9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/issue_201.evtx", testpath
    assert_match "Remote-ManagementShell-Unknown",
      shell_output("#{bin}/evtx_dump #{pkgshare}/samples/issue_201.evtx")

    assert_match "EVTX Parser #{version}", shell_output("#{bin}/evtx_dump --version")
  end
end
