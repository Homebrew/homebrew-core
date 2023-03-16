class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "00f83e985b544682fb617506fd5f1d567c95e64fa638c594fe86c71d5f103eba"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf17efc6e2ebb249fa2973864e34003ed4d6692a490b1513684e460d3592102a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf17efc6e2ebb249fa2973864e34003ed4d6692a490b1513684e460d3592102a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf17efc6e2ebb249fa2973864e34003ed4d6692a490b1513684e460d3592102a"
    sha256 cellar: :any_skip_relocation, ventura:        "090f4542f6df74d9a0fdc4c1f1800e070ceba76dfc2d33d30ac0db62cf25e006"
    sha256 cellar: :any_skip_relocation, monterey:       "090f4542f6df74d9a0fdc4c1f1800e070ceba76dfc2d33d30ac0db62cf25e006"
    sha256 cellar: :any_skip_relocation, big_sur:        "090f4542f6df74d9a0fdc4c1f1800e070ceba76dfc2d33d30ac0db62cf25e006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a3a68589a9c446052cc78dd8d60f8727556fd49f116d71e486aef6fc8a8e703"
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
