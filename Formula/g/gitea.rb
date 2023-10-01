class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.20.4/gitea-src-1.20.4.tar.gz"
  sha256 "f7a2c8effe05672d7b2840f6c5ce141725b87b8ec364cb929ccc3b96861807c7"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55867053e1bdb14b943dab0454a700e951fb2ea19a4635a062b74a5def7ab0e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "257883212f90aeec989f47ed03997f8a1882df7e060a611dd36f91227c07e544"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f1a345d528d62de1cc1ba6bda137238365bebd9c788a6b71636e8c2f94e520f"
    sha256 cellar: :any_skip_relocation, ventura:        "f6165fe66c0b0ceb3e5712291b850ac7532cdc252a9401d89fc0ef63ff99c044"
    sha256 cellar: :any_skip_relocation, monterey:       "c33f659891965d5642dd2c9b3e9cf93374cd24811e3ee3a14c8aafd803106558"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e5c5b28cea6f498b03808fc93a9ff078d59a91033292a9c84f680e25651c0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddcb63c29ede2867fe86a2f73bbbd28f7a7dbba75dc7caa2ecb123a0d735e08d"
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
    sleep 2

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
