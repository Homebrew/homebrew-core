class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "495e57a7ca05a9f03c3402040d99523fc2d684b9be76c12096df405391cdbe6e"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aad562a73958e8699ac34f1423d8fcf764c26a335cf192b1496fbdde2abe3922"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f19587fc45ac36b46181a069aaf17d9d87d1b20b0975bf529ab747d222d0de4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c2d16b71b902a49993131a56ecba8700006a8c25c10ba05a7ac377f12320c9f"
    sha256 cellar: :any_skip_relocation, ventura:        "df583a056b93de2fc937728857ac75b34587c839fb96ab485e7774cfc1de797c"
    sha256 cellar: :any_skip_relocation, monterey:       "1035ca3cc6afd70a9b7d56c4d177436e2732ad224ce5435ca72c9163813ad604"
    sha256 cellar: :any_skip_relocation, big_sur:        "27b2224a2f9f95bb4eade1003b1fbb231d2eed5bebbd2c2128c9b1b942518659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0b31374e716660b072cc1822755d9f183c3f25bd8eb3e51d94638eb9ad4fd14"
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
