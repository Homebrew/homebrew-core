class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "c635447bcdb0b9f731e4ae54ac842c222ac6932bd545f87fe48fc20818b4c5f6"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45bf9c9e3bc79de2f55c4ff7e1367173b8d00a4a00bcdaa5bf176313fbf27e5c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "45bf9c9e3bc79de2f55c4ff7e1367173b8d00a4a00bcdaa5bf176313fbf27e5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45bf9c9e3bc79de2f55c4ff7e1367173b8d00a4a00bcdaa5bf176313fbf27e5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "64888662404d3cd4a8f39656f0ecd91d0305da7f0d2680f2fc6bf88bae25c617"
    sha256 cellar: :any,                 x86_64_linux:      "0e4bf47c2d2532f29da512962a0ed7e54cbfe24ae592555ccb0c6fe14e71d03f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
