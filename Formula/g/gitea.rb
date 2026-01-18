class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.25.3/gitea-src-1.25.3.tar.gz"
  sha256 "594f37000ac09016ed01f6dadb64f745ae3a16887cc0c97873cedd081f10ce34"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "072f405f39314a5c85336950105f95048fce111540c7e31d6351e5a3991986ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "113aa1fa7c7ea11d7e3a05c07a254629e2ca6be945aaa6601df9b72350fd96e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75eb9f7a8b595a1158abee96a31770bfe6d6952d0466c7a022e36a801a2c8a80"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac3accb416b40bf895ecb000b7768fbea2cd67f7d31fc2bf722b284761011835"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbbf2506e6942a7052d7f71df19cccd7c4d1874914dcaec28df1cd73e21d786b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ff64919c38e6190401c2c9b76e537f1c2ef9e2f9a3443bd56b0b95c3152067a"
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
