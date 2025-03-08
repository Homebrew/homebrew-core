class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.23.5/gitea-src-1.23.5.tar.gz"
  sha256 "1dbf85dfd3055c189917290e550c932b72d6dc2d530d1e8fa39526196b0f7f08"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ead535af311d9f9296e89a1642c81902e48c4cb5c8685cca3b435fea3ff1b0d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b01870cf0ed5cdcfa6d981e8210871f605f80d9c94e36094f046d938a16e0fa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f7ef9148981dae1cebc51a0ac93d0ca98b3955a624dd6d38cf4eb38acddab7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c380d5e916a4751d783befef2ed0022c28571d018f644804f49b05a973133ba"
    sha256 cellar: :any_skip_relocation, ventura:       "886564f61b199b33365c23e811f266e62786d01b14dfb07135e6ac2fbfe019a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5451f8e404ad7bd590bba3302607f5f17cd4bd523bc5dc599474a7a7c814f1b0"
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
