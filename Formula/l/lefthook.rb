class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.13.6.tar.gz"
  sha256 "532eef2738f030bf2d87bc3c34292d235ac9f262b6644a14d938488baa3e096a"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f81f3e06a19eccba939115e18d66ef239f57efd8d7758b40b34a480a3692856b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f81f3e06a19eccba939115e18d66ef239f57efd8d7758b40b34a480a3692856b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f81f3e06a19eccba939115e18d66ef239f57efd8d7758b40b34a480a3692856b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d98d5fe1ec5e2005731bde950c581d5a5adee9554c6f1f7ccf3be760aed3d51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f0d8f9e0c4d843df048301614759f38c88b59a66f4118911bcf36e90d444d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b6607661c2a7508034cf2199a8d1006851a13c76a7214123a551dd5b20fa04b"
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
