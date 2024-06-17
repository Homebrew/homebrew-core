class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.6.16.tar.gz"
  sha256 "4eeb270e20e0a00145e01bdfbad4f32c7e720d762cc5c51da88d6db45ae4b6be"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edef6da864c650d623338f443618cde44d4ac588c3b4f28885f03d7a5f6cff34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa48f42623f01609a4eefc16b6f0fe5ea9d5353dd371f92dbc41f3d5594a9e16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4dfa3697debfaaee6ec918368e81516de70623ea1ec9ade2598666760e94e41"
    sha256 cellar: :any_skip_relocation, sonoma:         "c55cdc29a4804a14f1376d76227d4f3dbb5030964427848fed437ee1b8c4a1a5"
    sha256 cellar: :any_skip_relocation, ventura:        "c9baf13dacc8949b10d2fe9175be3549cfdf4aeb03bbb726100708961bbccd1f"
    sha256 cellar: :any_skip_relocation, monterey:       "583012b79ea5317dbe58a94ddcf9b4c908e502c621bd03e9f758bb3712d4f677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ff500ca7b9fb16f7f8e53de2f25ee2dcea0bed6cfcde41cbecbb3702f4020e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
