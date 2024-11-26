class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.22.4/gitea-src-1.22.4.tar.gz"
  sha256 "9f4fde87854547706409b5796378ae0f3bb734070f8a85ba36a8772ff0389d8d"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36566b68dfdc90f73d15c6a9188dcd6790cd89fda5b165da8bcb1ed41980baf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34e5f917bb087634a28165ef8525fc5f20ed5fd453feb8bfef90dfb922f02b47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cc74829e0de742a033882d49ede13c9245d55bb41f62049724bddefdfdb3c43"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad5cdd6b024453abf939947c0622fad363f28414b018eb2689330ed441d98f7"
    sha256 cellar: :any_skip_relocation, ventura:       "ccc34e71e3bce662b3227094b6c2d7fdffb5b7ff57a741e2e539e202f846687e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09c543fa8fd948bd0be8d14dd5296b307e25bb78acd9ba8a29243f6721679249"
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
