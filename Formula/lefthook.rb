class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.10.tar.gz"
  sha256 "cf4d299f97a743d671774b2a671278b9519f344af9dda2c84a04c0d72e3071f8"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eacbf8276c2974d4ec03932f9c247c9dae8925ba8e8ab93045224141ffcf1f3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eacbf8276c2974d4ec03932f9c247c9dae8925ba8e8ab93045224141ffcf1f3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eacbf8276c2974d4ec03932f9c247c9dae8925ba8e8ab93045224141ffcf1f3f"
    sha256 cellar: :any_skip_relocation, ventura:        "99f9ffd76ffe408cd55e9be5fe62cfd87016ca7f0bbcfde9d281b222bcf80e8c"
    sha256 cellar: :any_skip_relocation, monterey:       "99f9ffd76ffe408cd55e9be5fe62cfd87016ca7f0bbcfde9d281b222bcf80e8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "99f9ffd76ffe408cd55e9be5fe62cfd87016ca7f0bbcfde9d281b222bcf80e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415e2eec68f36da8ee2e9e565e4839501a3b2204f5c365c96ef9dc1f2e28c07b"
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
