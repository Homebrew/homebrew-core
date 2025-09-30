class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.24.6/gitea-src-1.24.6.tar.gz"
  sha256 "92ed113cb30687d734a0cc93a29e95227fdab7977020cfda0a5db72b6ca6c12b"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c45a613ab6350a9c69d5b86da02b4a9e0a91b52dd68a941abc603bb88f0776f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f6244cc8b99e4101d956c3526615c03b790f8bf1842e031af0619394a71976d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6b58d718b1a4191391a730e3a2405a265d182ba4547c8c8b64c06eece043121"
    sha256 cellar: :any_skip_relocation, sonoma:        "cee262534d40821523c48a1eefda249a8909d7fb8f2dc1ac21a570d061311ac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb24292a80e99b8cc0628d1ac47b3af36f74eb7517f9a616f4a786feadc56cff"
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
