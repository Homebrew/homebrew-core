class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.21.9/gitea-src-1.21.9.tar.gz"
  sha256 "e28e694a40bd8e5f2b23af276a8ac3ad1138466d3f7218f7f9c47166aa338885"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8641370fbd57faf41ce64ce88ee4dada7828de11987998cbd82bac8b50c3d639"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea10358bd086eab6260ac0c9c2cfbfdc63ab926c3512388230a96ba87cc23377"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9515dd298cae8709e0e84d12b4bdc3f30e96b8d2e43f19192b5221883e65c88e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa8f5668b7c0437764bb586960a9bbf73c812dc9b86900f4668ec4d7eea4b148"
    sha256 cellar: :any_skip_relocation, ventura:        "ca25cfc4eb95fb0c4a6ed9bb6c993be562fafcc73dbe7188ab63b33346ed3ba9"
    sha256 cellar: :any_skip_relocation, monterey:       "72a1823fe52b47c72d293478d3512eed5ade0fc9028d287e48535943b4d9a0c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2107821d27a03f75e874c01b3950bdc2200d87ab6bf0dc634bfaf0b784b6108"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "sqlite"

  def install
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea"
  end

  service do
    run [opt_bin/"gitea", "web"]
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/gitea.log"
    error_log_path var/"log/gitea.log"
  end

  test do
    ENV["GITEA_WORK_DIR"] = testpath
    port = free_port

    pid = fork do
      exec bin/"gitea", "web", "--port", port.to_s, "--install-port", port.to_s
    end
    sleep 5

    output = shell_output("curl -s http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Installation - Gitea: Git with a cup of tea", output

    assert_match version.to_s, shell_output("#{bin}/gitea -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
