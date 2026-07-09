class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.10.tar.gz"
  sha256 "9a0b4b2ff3f31a4cb16347851826be6791ad70e123849cb34acde8cd1b99eb82"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a27b50bcb5bb33a451edb3a4e3a36ef234a89ac9f77a893f7b7624d9a3015fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a27b50bcb5bb33a451edb3a4e3a36ef234a89ac9f77a893f7b7624d9a3015fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a27b50bcb5bb33a451edb3a4e3a36ef234a89ac9f77a893f7b7624d9a3015fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3afce0173c35d1363a204e175b9e544a4002c7581b085d247a15f84eebd5443b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35b13a162512e6cd0b50f1cc441ea1642341cce955c1417f3a4a27ba15b45f76"
    sha256 cellar: :any,                 x86_64_linux:  "9cc2cbe3c3b3560407e012767787201907cde70e149ae25a3793e381462245ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
