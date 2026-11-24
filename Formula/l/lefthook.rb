class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "8fde63137b7249934dee9f35be38200bb02760021f82b6920dd9b2b58f843558"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "05764808b5931eee64c82a28ab8500fd53bdc66fc434f6527be6e881952c23cf"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e42ae96debf32997943109534c61fdfd3682d01295f44d2b19e48d77256b5b0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e42ae96debf32997943109534c61fdfd3682d01295f44d2b19e48d77256b5b0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e42ae96debf32997943109534c61fdfd3682d01295f44d2b19e48d77256b5b0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "71b78f0c9c3199e423b8f9bd5e351c0d3e01d5aeaf8313a2ddd8f9473113ac05"
    sha256 cellar: :any,                 x86_64_linux:      "568f1be6ce70d3fa341e0233cd698e62ac057fc1edf42ca0e3c18835e94afe2e"
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
