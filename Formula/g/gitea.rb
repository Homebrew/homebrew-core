class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.21.8/gitea-src-1.21.8.tar.gz"
  sha256 "9c9df9edc92095745c976d390a0e2d83d7b098b9f63242940d4dcfa700559629"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7fb8da9867aa816ab67462fec9fe07ecd030263dad0829a6c4309a5b9cf109a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7596d44990d4f5aa246905351d176e006f3c292def3cb951e2b9c09022b12c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "668a1770d60994fcc739bbf32449e0f1ceb392eb50d62034209d9fdd397dd423"
    sha256 cellar: :any_skip_relocation, sonoma:         "74f5fe111a996fbecb6df8d61c1a48eb9ff285ade1afdbe1a34af90423236002"
    sha256 cellar: :any_skip_relocation, ventura:        "2f508069e389dc6ec73737da0c2dad4cc2fa42ec2a7f1b58ed5c66e8cb7603b7"
    sha256 cellar: :any_skip_relocation, monterey:       "2c6c6f59cc559fe708b8d85ddbc4b9356b2e6d965788b42c862b8fd7eddf1312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "962573b962e6aae89ff3c2b526ba63fddd2dc31e87696769cac669fb8e0381eb"
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
