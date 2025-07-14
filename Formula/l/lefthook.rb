class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "b35d1c30854a03fd0d92fa28c50ed1302f52b8b350fe6ee4a46f3c3db59ba08d"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb7e7e64ea4d0b8f531eca9cdecc2266bfdd4945c6ffa480b246b19a182dd34c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb7e7e64ea4d0b8f531eca9cdecc2266bfdd4945c6ffa480b246b19a182dd34c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb7e7e64ea4d0b8f531eca9cdecc2266bfdd4945c6ffa480b246b19a182dd34c"
    sha256 cellar: :any_skip_relocation, sonoma:        "07a0ac11d7e979772f27db947a68d7372665615f19743af0a9cb4bd699b9bfef"
    sha256 cellar: :any_skip_relocation, ventura:       "07a0ac11d7e979772f27db947a68d7372665615f19743af0a9cb4bd699b9bfef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dea974a9e7807e0912fab79e41aecb0756511ce1da60c5ae9643699807732acd"
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
