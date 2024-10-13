class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/refs/tags/v1.73.0.tar.gz"
  sha256 "c360b5118c3cfac724aebe107ed03b9af09b201dc189ae735589a7a3d75fcf7e"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf76138da81b0cf596eef9743794f933c0d086f034c2589148c2a89bbb8a8acb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b23f66521f0f730865d23d9305990ba11807eb1d539ba90394bbb4f282bcdf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b23f66521f0f730865d23d9305990ba11807eb1d539ba90394bbb4f282bcdf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b23f66521f0f730865d23d9305990ba11807eb1d539ba90394bbb4f282bcdf7"
    sha256 cellar: :any_skip_relocation, sonoma:         "45f9bda916bf3da1b367b5580283841e9f46799fda8e01aed128a2e264ec3f64"
    sha256 cellar: :any_skip_relocation, ventura:        "4891e7e65214adfbbc5543737281be8bfda669964f8dd2bab40794adce9f4bfa"
    sha256 cellar: :any_skip_relocation, monterey:       "4891e7e65214adfbbc5543737281be8bfda669964f8dd2bab40794adce9f4bfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "4891e7e65214adfbbc5543737281be8bfda669964f8dd2bab40794adce9f4bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "920be82872a3ea62308092a58e929eef0bf95c54027e772acfe7c23425a971f0"
  end

  disable! date: "2024-09-09", because: :repo_archived

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("#{bin}/dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
