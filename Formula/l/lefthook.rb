class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.9.tar.gz"
  sha256 "33dece7ea494fa723cd1a8488210dab807c1be9d3c92912a0eedbd6406299744"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d44f5734bf3524e0a02760ba51fa2f9d1ab373851be28aef0ea72c9c6177a790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d44f5734bf3524e0a02760ba51fa2f9d1ab373851be28aef0ea72c9c6177a790"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d44f5734bf3524e0a02760ba51fa2f9d1ab373851be28aef0ea72c9c6177a790"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d04ad3efff0046812879cf1d783b550ff95d2c9dbd112861e5cbebbd30f12f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7bf3c10d85759c33789fcf46f5dad5527ca793fc9f260f99ae8850fb6e2e580"
    sha256 cellar: :any,                 x86_64_linux:  "7530b5c20cf52ff892089401aa9f58e7f8ee8663f2857979b57704dba3cf3e26"
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
