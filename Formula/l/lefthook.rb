class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.7.14.tar.gz"
  sha256 "a4124aa6a31607044c25770b938c506b15b561de7f270a0982c8b87e2024e12d"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9319c8d671bbac12adb02c86bdd536e8d49d04cb23b27d12d44259e0d3ea9298"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9319c8d671bbac12adb02c86bdd536e8d49d04cb23b27d12d44259e0d3ea9298"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9319c8d671bbac12adb02c86bdd536e8d49d04cb23b27d12d44259e0d3ea9298"
    sha256 cellar: :any_skip_relocation, sonoma:         "17ba538e549485248ec7dd5eb4b976e136b7f77472a65e357d4d4a8c8cb05a94"
    sha256 cellar: :any_skip_relocation, ventura:        "17ba538e549485248ec7dd5eb4b976e136b7f77472a65e357d4d4a8c8cb05a94"
    sha256 cellar: :any_skip_relocation, monterey:       "17ba538e549485248ec7dd5eb4b976e136b7f77472a65e357d4d4a8c8cb05a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7793512c46d00a6bf338f65a15b564fd77e6d036d3afde6e5dc8ddc7e78fcd8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
