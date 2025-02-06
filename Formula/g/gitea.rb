class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.23.2/gitea-src-1.23.2.tar.gz"
  sha256 "4e37f620b6c5450bb4000f0a74013b109f4cc71f3adbbb7f6043c366131b2c24"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdcfb18249b5717081b1125dae87c87a4942ee510ed2fdf615cbdb7894fc2651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98e507755f593c12b1bf3c8045c062fc08147ec8100969f0deda32f1df980f26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1c8142392f5aab07c8fd65ced1dbe6800716d60afb0e92fdf3593e65d17ccb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d30b19c373928b2a3aeb3486e4d9d353e97fbee9ca53cd3898dbdddf29dea72d"
    sha256 cellar: :any_skip_relocation, ventura:       "a730f73f697c3dbab06a1db2c2699493d87081a3c1403606a8d7ba0a978ad747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaa3386f3091c9d6ee60ba1bbafb3a0e5a1e7f7a237022cdc97dea8a841d4bb2"
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
