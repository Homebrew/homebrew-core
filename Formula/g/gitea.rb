class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.26.1/gitea-src-1.26.1.tar.gz"
  sha256 "6c673dfd26c6e22dfba000c6dd1e3eaad905176ee7c80a5f458bdbe54caba248"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17569aa373ae90f6c68b20f0de153d073bbf696dca4a74be9c48348de504d7cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "300904374fc76aea8b69c94fba0d77ce4092ba5f92c3abdefeef8b879467fad6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68288566df5b3803a2722f38c92c2d1a3be0a8779e8aa9ecb715ce8563cb9251"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad7589fd21dba2ff2e9716a399d60e7e190839727252b428dca447de1efa2dec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d36ee30d30585c8c2c264268853946b26be54a82d4f7f66aced4aa5feaf6b2f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4309750a27f3ad05536257d33e3c50bd7b735f1e36cf549813f30396def6ca63"
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
