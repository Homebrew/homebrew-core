class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.15.tar.gz"
  sha256 "5eefcd5633a6410a1cc10112323c10daae0d578988ca320c9663195d2a9f9722"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5551c012f97258b6473c7b525313db397c1cf3a9ed4aa1c1f20be26443607d48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5551c012f97258b6473c7b525313db397c1cf3a9ed4aa1c1f20be26443607d48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5551c012f97258b6473c7b525313db397c1cf3a9ed4aa1c1f20be26443607d48"
    sha256 cellar: :any_skip_relocation, sonoma:        "569fb6c30e46aa18a9ff261758c7d08f5e955b40e7628e7afe647f4c94e6190f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dde7c62783fda0f9bc802a9c03dbf0da534a5184937c0300e45c6c7030a1db33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c76f8a0bfaabbf7bb8bb70b0e61c977d951530b60c3b996b24308c1137379825"
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
