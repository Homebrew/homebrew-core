class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "a396d1fdde4b7890b8a8487af9da230976e5cd821f8901dff5892b03141dfd4f"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e8f96e03491fa8bb206e2c9fd072f768b5c576f0ef41f380c034bd3b9fba36a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e8f96e03491fa8bb206e2c9fd072f768b5c576f0ef41f380c034bd3b9fba36a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e8f96e03491fa8bb206e2c9fd072f768b5c576f0ef41f380c034bd3b9fba36a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c05d606261c273efd73b35aa0db31507c01ab28c371be0f87a08d20484bc22ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ad6e7da26c8a9c0a98aa00f493fc4d6560920cdf7882c31bb5a2bd87b47a39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e6d8b3279f8312fbac6f12033168aad2151c8bcdb719b2a4ce89bcb17e05dd4"
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
