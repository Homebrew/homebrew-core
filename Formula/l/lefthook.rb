class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.14.tar.gz"
  sha256 "b1a99784f93339b24a24731646d4489d2f3496c4f79c9dac449aea3d92fc2be0"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b16123bdf9d8e9c69077b4fe3ce48a17cf030f4a91a372f51e49b69ef39fd3e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b16123bdf9d8e9c69077b4fe3ce48a17cf030f4a91a372f51e49b69ef39fd3e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b16123bdf9d8e9c69077b4fe3ce48a17cf030f4a91a372f51e49b69ef39fd3e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4c5d154f085f935537a9fbd3889592bf75e9c3b00220d0a1f85ca6cdea44e1dd"
    sha256 cellar: :any,                 x86_64_linux:      "232cf8979b7f02dbf709fa12781d9bce9fbf696fa20d1a309d7f53c2fefe2608"
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
