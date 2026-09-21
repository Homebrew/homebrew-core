class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.27.3/gitea-src-1.27.3.tar.gz"
  sha256 "3283ae40dd1f7b09450bb5a56455e78106fe17f4211d254c7c0179b8927bf382"
  license "MIT"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "68c5d078814215327001da895f3783966fa7d6fd1929cde3bafefcb83a7db71a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e745cce0048869e7c012e656b243e879656625977cd540f9ba0843c92d16d7b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "44f860fbf3429a7d0d8ef69bb681c3c68475d78d27f92358e95537f8bdc3cde6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5546c8c86cad8c950ca230c6a3c2dbd87b2836e54753cdbd75ce84aba6cc92d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c74bb2e980b2d5f5ae4ab26524738596ea56a7b89e619b3ba211e6fce7bdccea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dcbb9d8029716b6164ec34f2d7697e7cbb0162fccbba5a4b3333d7ad5779eca9"
  end

  head do
    url "https://github.com/go-gitea/gitea.git", branch: "main"

    depends_on "node" => :build
    depends_on "pnpm" => :build
  end

  depends_on "go" => :build

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
