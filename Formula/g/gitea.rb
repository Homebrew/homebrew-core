class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.24.2/gitea-src-1.24.2.tar.gz"
  sha256 "1015496a01a95821faaefce1d422ecdd98f62bc609efbeb43608772612ceeeff"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5619035d3d5c6a5b19a2c7bac3a8b1fa4fe71ae955dd3309da28900bfba319f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70f3c93d1126696676b68b46f484ff323cd4599c75a5e001a72ece8aa98317bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f2607ee84b5cbf68ac0b90f9ba1ebbc4f0531c18c5fc26f133e43d4da24c866"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb61673286485958dff6a8e31e8128ba5404db514fc7fb1eda0b74a5b52d9b6d"
    sha256 cellar: :any_skip_relocation, ventura:       "74464f638bc83f7f028a1a61cf67011fce3826e96bf3df62b408242273f12917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e86e4c96c01bbd0fff61ea2a8062987bd1f5f6934706893a24270a1d51114059"
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
