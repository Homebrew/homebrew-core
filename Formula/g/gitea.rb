class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.21.6/gitea-src-1.21.6.tar.gz"
  sha256 "b62c568a98951ee81a713cc1bab7607e22e72b25430dca823e5cac8f60e85a38"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72c7c219bb56af90de6173af1f907405fcf74469c7add695ba44808f66d8d731"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94237ab2bcd25a4bb0a165895f7110527e514201444268b370f3c9f95bf6333e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13cc18c4ba99f4b3947d1a2d2891b64e616686c5dec983d5750438221e26c96b"
    sha256 cellar: :any_skip_relocation, sonoma:         "012a3e08233cdd2073ec513df147b25d510bf10aafa483e337b6d7e3c352e74e"
    sha256 cellar: :any_skip_relocation, ventura:        "86d873a161a9038baa3e4c9302ff4b596e2f896277626681e6ee9941e8f95597"
    sha256 cellar: :any_skip_relocation, monterey:       "0c44440547844a1ec0c2ad6299147d76e5dbe6a3f71d4e259a00195e079743b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f409637dbe59713a94ab455124aedc18075cfc3737260e533d8c6e22b1d88d9d"
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
