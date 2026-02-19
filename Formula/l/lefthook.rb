class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "02a5bd2d8fdbc6179ef1b279b5703c619c5356be9082a71351298b7b326132f1"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "152da702150868f11a7e32f6dde03fbbaa837124551d48e530c5f7e0f5aecd06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "152da702150868f11a7e32f6dde03fbbaa837124551d48e530c5f7e0f5aecd06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "152da702150868f11a7e32f6dde03fbbaa837124551d48e530c5f7e0f5aecd06"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeb2b7a0a4d971f6932353cedf0e753f05fc0bfaa1a9c8dfed109976fa6fc02f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "992bf372c476c681000dca59cb6650e51d053867193d66c9103f73b886dbebdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9bda034d4aa3006186679203bfc5bc8c9dbf05626c00036e75ba4259d119e13"
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
