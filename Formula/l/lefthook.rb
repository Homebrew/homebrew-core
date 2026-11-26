class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "40a8ee5ea59e8d21ce18a6941cb79d1bef1a9b51d73a42ae6f1945765d9cadcc"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "511b0c07be8f461cb36165122966eaf92c8cc0798c071bf90c620674e8ab3e43"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb0cc5f55ca4d34828e165c389422e412cccffeae73eaa68c791ef75b9e0d7b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fb0cc5f55ca4d34828e165c389422e412cccffeae73eaa68c791ef75b9e0d7b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb0cc5f55ca4d34828e165c389422e412cccffeae73eaa68c791ef75b9e0d7b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fb44012a3a767319f2642c18da8714ee6f4675c797f1b287e223b36491f313a3"
    sha256 cellar: :any,                 x86_64_linux:      "a6b63b40e56faeb3ca5b72b75308b79c55ec338de83a9bb53971b03232c6d5c5"
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
