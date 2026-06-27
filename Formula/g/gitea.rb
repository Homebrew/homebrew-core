class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.26.4/gitea-src-1.26.4.tar.gz"
  sha256 "197d679d8c774e05915c67da67d1cbae9fb055c1dbb802f0c59603a44fcadd98"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2ea6977b59731d61c06de9245dbc58edd445fb642eb6fcb253e984c451ccacd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "781384f061cc4041438398c0290d57445af222c778d825544c767bea6373a6d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "667fee745095f7483cc0b5e5f6827b10c14229fa1367f88905ce697cb8a59825"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce60c966cd8ff51a8f668805b54bee528b54ba45f29954aa4adb5c4b8e491ac9"
    sha256 cellar: :any,                 arm64_linux:   "8bcc77610eb015b6f8fa33faa561293b2bc5a1807efcc5f4b7a20722fff84e26"
    sha256 cellar: :any,                 x86_64_linux:  "5b8e38b1b80bc501ffbb5d67ddbd4448eceede5381df431e3c7506d0cfb23638"
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
