class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.20.5/gitea-src-1.20.5.tar.gz"
  sha256 "707fc01ec15739dbdf49f8fd01951dde5fd1958134ea8d41c99bb4bef190b97c"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc258e67f645cc19bc4c86163b79bc3be9546feecaafff2cdb3c0b1b885c28f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdf6a53817e3631d499eacf805bb4e7150badcf2fc2a950b0e324ad916520190"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0866d2ae5a2000e8a5b98e366e3158de6c6e59386a1b57db1a8e6c439836d3c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b1a570a102c059c3227af04690d24ba59f68d41e11dfe9b2e5385d8362c5c7f"
    sha256 cellar: :any_skip_relocation, ventura:        "c8a55bec59d5ae4ca5c9a9b11e597fe236b81355e9d34881ea821f725862122c"
    sha256 cellar: :any_skip_relocation, monterey:       "b059c78a59f6f491c7bf1ba3ffd6fe02188158e2dad8e7292612e0f18298f6e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "098211d55f007d79182d6b0483ad55d0bd1ccca318cc41c805101709f48fccac"
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
    run [opt_bin/"gitea", "web"]
    keep_alive true
    working_dir opt_libexec
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
