class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "ba1345c88b1e62931ae0d410dd908ca53c39531459db23c1312f5ffd947316ae"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d86b705f1556d0a9a21e23b2c6efdc4e8f405c9e54c03628c7dfcfd8d59f135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddceeca13e706d54b213128f5e88a6bed255a17cfff46d84b9579190bd134a2c"
    sha256 cellar: :any_skip_relocation, monterey:       "3aba9a9a5357883178432f68bbf03f26679d24d2a8d1ce4d1a107105a941aa3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d4bdc980e23027a17323a3b4bea0e151a839258da48720b4b48c4e0b570aa8b"
    sha256 cellar: :any_skip_relocation, catalina:       "9abee55d0c1f57f8017266a85b15d15aa1f05a36f9c2a5a77ea441bcc53e8016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6dbd8b5914f6b9f26034ce08ff38af6348a6653521e4f800fde6b1fb65df99f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
