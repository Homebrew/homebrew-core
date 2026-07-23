class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.27.0/gitea-src-1.27.0.tar.gz"
  sha256 "012df875bfa7764ade92301ac5e4225fc2c2aab7b3b40b4d6e7149a926253496"
  license "MIT"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03024c4416a19015b6293ed78e5d3424c1ca5c2eae58840929394c73be0214f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4711e87541a2da8cdedf7d4b0d6c382f7ee104c32e81aa7f55aa30a001db75fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48be4450b1f00a107a5c33ce63a0afe4800cb2491607aabb3aa0e650aa19ea51"
    sha256 cellar: :any_skip_relocation, sonoma:        "588e1bc90c9b07b0bb68e012ee8bfdbf5b30e9e6c53c2ad1bba8dcc7d8fc4f27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "559b3d7fd993a775745e75c7b930b8e706a8ab1aa27ab59b9fe137e79df293bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97d9ed4989278022473681ac185dbf0690a75a89669f216dfaf225fa225f2146"
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
