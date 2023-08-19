class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.4.9.tar.gz"
  sha256 "bee9605c7b8c6a809d82c7ea594d19dbe3a503c7c82ec7130b95c40b7a38de1b"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b388397e3776db9abbd06a0d2aca86b180d7c5e2bdf9ca85ff02a078214b58d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f19f7b44a3e1e9bbec41a50a58127d3e95537552d752dbc975bd0063e93a3a41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1693ae2f6258162f7500f7969dfd83143e981da6eb6d0e73ad332dcf8a0b88eb"
    sha256 cellar: :any_skip_relocation, ventura:        "1435e7d563dd6c0d2c7123e91b3316d239a7c042fb71e71d2b2801643f93f1a8"
    sha256 cellar: :any_skip_relocation, monterey:       "3e5d528e20d1e789d7090bab1a30fbaa70bd0c88266dae73e9601aebf8988c19"
    sha256 cellar: :any_skip_relocation, big_sur:        "23307118ac5ca48b56a9fbea10b788ec24234dbb182934f83fd41e90d91d786b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3884badc77a3a98a47263f8ee2afcdef3f126493a4c5a46ff9096f296d38b20"
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
