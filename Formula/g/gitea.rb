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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0407b7ea182d337257e0f79caf5261db3e1949099d1e3ede25c2de24155223c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b10624e83653f5c6e132fe12ea4329bbb54246d10f4bd4b5e426d7e884d0b0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03fc9b52d3fb91fb7eb0ec9d0020cc9a32556633d17dc907e434ab6288e2b934"
    sha256 cellar: :any_skip_relocation, sonoma:         "0396333d42721709ec013ddcd1ea7175379681f2fffa60f3e78e245c045ccbcc"
    sha256 cellar: :any_skip_relocation, ventura:        "ace819fec9139db35d5e0231300db95f9cc37b4d87c71e6ee249711b74b241d7"
    sha256 cellar: :any_skip_relocation, monterey:       "f33f68f8b88edcf8db5494ebcce1be313599b55037c1c97c8d5864f14fec2f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb7eb0df6a2842161d94191e189adb6c89654eafcbfad420b5d2f496d2931974"
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
