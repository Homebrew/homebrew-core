class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "d8238c3fcdecbbf580039170fa526606ef90554999f1633a2e3947d144184a13"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1494febae2ebe75e037919c053ee5b473663039f661054903894370cfa2ac0ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2561794e3c703af2a4ee7aca240f3e21c6c43211c4a69a4fea6218866c7fc12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c204d61fb0e86a09516f294f11fb06991cbde6c270ae172d894dc27a1cdd98f"
    sha256 cellar: :any_skip_relocation, ventura:        "9457626366449cbf3ee1779919a025e78186ab6f22c179bcab09237b05f372cb"
    sha256 cellar: :any_skip_relocation, monterey:       "4d35de622a72ed14fab4f0870bdf265f7f24b6907deccbe66545a04a6992d467"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dcf50691d83210540d8c9347ab5558b242aae06fdeb5ba1615ae3167afdfa36"
    sha256 cellar: :any_skip_relocation, catalina:       "aa933d78fc6080aeff1cce4984b94d422f9064914609633da003e783bd388033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ac9a8b50e899aa37cfad496693c664a77f9ff07faa50e5f5e3e70faffa08b8e"
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
