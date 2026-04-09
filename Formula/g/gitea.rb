class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.25.5/gitea-src-1.25.5.tar.gz"
  sha256 "94ac565aa9da5b80e784db53598e5b10a2e41c655c07f064050675bd97ef51f1"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4024ae5a2e155b8425ec0036093e670c6a69725e25ae52874c08d8c1ec6cbd97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa260bc0f983f70cce8fe23cfc76b1de6ce4bfafb7dd6b62d438c98ce3c2027a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "106104008cab4488301720477be05fa1a35dbddd611acf940df197c783c846fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bc8a894f872eb3c796c913d1378c4f67b57662fb068deb5b0634fe19e5b8e72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66e3158cb36beb08784edc27acaf2cf1001b9b4e89a2878193132ce20569d84b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d9190101ba9b439c299717d82e2ae4ef7b86f87fd7975fc189679f7b036bdb"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "sqlite"

  def install
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea"
    system bin/"gitea", "docs", "--man", "-o", "gitea.1"
    man1.install "gitea.1"
    generate_completions_from_executable(bin/"gitea", shell_parameter_format: :cobra, shells: [:bash, :fish, :zsh])
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

    pid = spawn bin/"gitea", "web", "--port", port.to_s, "--install-port", port.to_s

    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Installation - Gitea: Git with a cup of tea", output

    assert_match version.to_s, shell_output("#{bin}/gitea -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
