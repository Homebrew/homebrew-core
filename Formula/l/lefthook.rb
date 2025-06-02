class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.11.13.tar.gz"
  sha256 "c5e4b1d24fa700bec2f3c1ac5332ff2c55db76a8a13b26783fa72f6ea4970370"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14b9c4d773979b0c0f8b3d5af4e21f00daa79bcfb98309e9feeaee79651fa91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d14b9c4d773979b0c0f8b3d5af4e21f00daa79bcfb98309e9feeaee79651fa91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d14b9c4d773979b0c0f8b3d5af4e21f00daa79bcfb98309e9feeaee79651fa91"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8c5854b8ae874a9449308c5c6e62a3b8c5d789a6819d5a17f18ba8d88d839c3"
    sha256 cellar: :any_skip_relocation, ventura:       "c8c5854b8ae874a9449308c5c6e62a3b8c5d789a6819d5a17f18ba8d88d839c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e545408ffdbf6c9cffaaf2f4125f66af3eeab37624e3224db3e8dbba8d14173"
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
