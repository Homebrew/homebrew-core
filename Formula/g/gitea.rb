class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.22.1/gitea-src-1.22.1.tar.gz"
  sha256 "f17299ad5051190b8e8b4e36e7daf2a7246a779430f5c3810370f1eb978c340c"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf68c6356c2b245dcba201f16a0a23971085282ee11fd69177c475edbff07234"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a67c57e7f05011051982ae86878cae6636a462072bc100b592560fed91d41c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "decd401934e2a320837ac9a8fb7e04d05c07cbe0f5ee60ddf64e2819d93a2865"
    sha256 cellar: :any_skip_relocation, sonoma:         "b57e2a0ba7ffdf239f0e091c9009be9f45e71981920faea56010a752620a9dc2"
    sha256 cellar: :any_skip_relocation, ventura:        "377f08cc8220df179e4ac00b6015cd02859535e65a842fc942b17d8f71d741dd"
    sha256 cellar: :any_skip_relocation, monterey:       "7c003a0107cbb0aa6a026fc883823c9f177bd758a235a3eda17dd0f0ead420a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b1ddeb4358caaf44340d76bf63b65ea1d5c4c0e291f6c6536d68ff922c335d8"
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
