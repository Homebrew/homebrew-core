class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.23.1/gitea-src-1.23.1.tar.gz"
  sha256 "da4d36c4c9fe3980b4ba130526cf030ba7dba51d3a6844c6723a6eaef34b6df9"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "110c16e0fc3c10963c9da4a9ac5c3038bfa03e80163022a6c8d0e0e0507cd7ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5af324f2d256ac478483ee4fac023167ee13eaefeac2ea2c9de6accf002441e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "caf2609afbef9c6288998cf630fb00f7efcd943b018df464ebdf20e2c79356d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef67d1bf74eed992202506da53696bd4e44f11188e98247b4dc34dd166193f52"
    sha256 cellar: :any_skip_relocation, ventura:       "741871bb723e355b4f5a6af665e7f362d8537cb73bbe8f06a66846467dad718a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca371f29f2b6ba07b305f89046f008d048bdeb965081e39778bfed15c6ae3414"
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
    sleep 10 if OS.mac? && Hardware::CPU.intel?

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
