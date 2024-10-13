class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.22.3/gitea-src-1.22.3.tar.gz"
  sha256 "226291c16bc750c5d8953a7c16858ec5e8d87751308d25ffbbe75210f45215c2"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1d0c13ceaabc6e1a5c051695a7e8a50fdf503a86868ac36da518af3baa064ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea7a684e7119870d8a7ed93feb0eb7f110192d21af215ebf5c6c81baffc7862f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b32c7c0d19f5c39077967b28d3a32e0479b7322f0eb603382d9fdda1e10fae54"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7371da1e00ff20ea938ee1d956692eafcda50decff9aa6f3e3c645c69152243"
    sha256 cellar: :any_skip_relocation, ventura:       "989e7a6e0339ded0f06fef9bd7a67a9c2d4bc8ee7e47154beff53745cfaf5737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbf3f66b9fa2d8efdaff27fe550a4c7e18d9b9b7094e0b602578fb1a71125c79"
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
    run [opt_bin/"gitea", "web", "--work-path", var/"gitea"]
    keep_alive true
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
