class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.11.11.tar.gz"
  sha256 "64443325947701ab902611663b9ddf5c43c1dec2223e59941ba7ad8c15ea2a86"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4999ad26169ff9c6dea3206effdcbb00698ecf9baf409f3c065844d5061c97f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4999ad26169ff9c6dea3206effdcbb00698ecf9baf409f3c065844d5061c97f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4999ad26169ff9c6dea3206effdcbb00698ecf9baf409f3c065844d5061c97f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "144662f2f8725f1c264ba22a355065b41629a1914b3bf0fac957a076384596c0"
    sha256 cellar: :any_skip_relocation, ventura:       "144662f2f8725f1c264ba22a355065b41629a1914b3bf0fac957a076384596c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae88842e23dcbecf788de0c787c9c3d455e41ac7cfc44cda2eb1b6784c93365e"
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
