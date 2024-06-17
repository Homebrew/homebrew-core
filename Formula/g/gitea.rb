class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.22.0/gitea-src-1.22.0.tar.gz"
  sha256 "6d4e2efd1b04d762275e327666f20bdf5cfd03307b5d42f2574fb2b40627ca38"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd918b0e36b417fb28f64c9dc7b41b79d287ca2cb93501f63ee0c9bfa8684a40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7a39f0b8f19fe4d286b0da11729819eafb46b71408c5aac82ef4f2f89aa72ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8e1950999605e2195523586ff744949dd33d1e37f047795f5063edd44dadb98"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b67dea0d2cb1508c10840ff26fce98120bf74e47b9a614ffeebe66d84b25814"
    sha256 cellar: :any_skip_relocation, ventura:        "cd6adb7bd440990e50d29bba1c648945e3b51abcb7cf4691f103e51645bbecc0"
    sha256 cellar: :any_skip_relocation, monterey:       "2050689c36291d657b832aad88bacbd9affc7185a5a0b80f0c44563c6fa8f372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2405fa1d0f4a90f2be3a95afd7710e8f26dd48ccca311a00c9386580ba45a4c0"
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
