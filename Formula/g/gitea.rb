class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/28.3.0/gitea-src-28.3.0.tar.gz"
  sha256 "a632833d5ae02a18e8f7ed79177763801604de6ef6f6d1c1405029d28de9d3a4"
  license "MIT"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4440a72c0891d5adea82f72db590a67a80795168eb0d1631603b07e95ca28395"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "59777da241986124b8fefefed7497516ce136ee2d66e54dc7237de879935aee5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae31546e00f792cb572d5d4a7a94c17a83ad08a4b7bc035f7d7212a16c028d89"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "58ed11505f2e3c05a14e085b1bd4ffa219e4c7a37df8af474ec2b98042bb5265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d0995991675c607f67fbd48653beeae4096678236004ef5b7dc4c563a3fd5071"
  end

  head do
    url "https://github.com/go-gitea/gitea.git", branch: "main"

    depends_on "node" => :build
    depends_on "pnpm" => :build
  end

  depends_on "go" => :build

  uses_from_macos "sqlite"

  allow_network_access! :test

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
