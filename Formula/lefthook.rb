class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "00f83e985b544682fb617506fd5f1d567c95e64fa638c594fe86c71d5f103eba"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1e3654d81b2d8571dba177efdf85d3d0abdcab1dfc31868fb6685c03eea3dc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1e3654d81b2d8571dba177efdf85d3d0abdcab1dfc31868fb6685c03eea3dc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1e3654d81b2d8571dba177efdf85d3d0abdcab1dfc31868fb6685c03eea3dc1"
    sha256 cellar: :any_skip_relocation, ventura:        "ca3cd309152f2498704b532f6bf3a2735625b314c5cbbe285d0a5b66b01bb1fe"
    sha256 cellar: :any_skip_relocation, monterey:       "ca3cd309152f2498704b532f6bf3a2735625b314c5cbbe285d0a5b66b01bb1fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca3cd309152f2498704b532f6bf3a2735625b314c5cbbe285d0a5b66b01bb1fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "792ae6c28e0dd698d771b83c8b70994b9b9b45b376bc93d81a34cc6743e1073a"
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
