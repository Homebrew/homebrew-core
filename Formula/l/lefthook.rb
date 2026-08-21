class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.11.tar.gz"
  sha256 "c09f388e2f062a71165a9fc2f006cbc68d65a0d5ea5e75e8a069edb560c6cc2c"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3eb379002c1d46636a6b9aad310acf0679689cd0be80b82fb2e240b284af279"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3eb379002c1d46636a6b9aad310acf0679689cd0be80b82fb2e240b284af279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3eb379002c1d46636a6b9aad310acf0679689cd0be80b82fb2e240b284af279"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0b82ab12b7b7290096521e7d00db0b775f9bbd2db9cde075a818ba84c2009b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc64957c10fb7bfc96fc66d3cc1db11b93c2f4120c445e6144e91c5cf00e7d48"
    sha256 cellar: :any,                 x86_64_linux:  "e37be9e8f913137235f5cfcc6216091e8c4f3fdb8eb7e676ba22e45a4eaf536f"
  end

  depends_on "go" => :build

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
