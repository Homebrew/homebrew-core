class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.23.7/gitea-src-1.23.7.tar.gz"
  sha256 "cc96f04a3b49aefe714bf1d8004a5043a94b90f4cec7ae342f17917ef412a1e2"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45edfc8d23b8b2a1b105af9081a022bb465ea68481f68638069a8d2c5d72e15f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57afb307527d8a5bd9a464b6db43035a1a5d24140584867ccd630b4c0ec11be9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f64d6d968cc72b3b8b1a60cf5be34f7c7a8bbea5451b2808f6d9281e0595b58"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c98f87db77ee3ef8f9c979189a9366b470faa70516e5a4da0bdb3b38d3ae472"
    sha256 cellar: :any_skip_relocation, ventura:       "86f6ca474354b870b469deb17ecb20275d27a3436044c4236577931db4211412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47c02452d9e0cabba583b0a2130b0ac4d5d316c40eb038620b4c02ba0bbcedfd"
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
