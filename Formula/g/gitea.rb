class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.21.10/gitea-src-1.21.10.tar.gz"
  sha256 "83f68344800a68f8bc0165892f837c099b763781c11162bbc5206f8eb70f0c3f"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa4ae017911fb9ca9ad505cafb26f6e40881f14fdc66165dc81478d611f3a828"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0b608020684d69e64a9ef6eee04ba1c24cbe02461e9dc3b9fc33c70a02e03d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ba155f76035396634389f46e0144b82bc28902532b92ce801d6d986834fd7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "10ecfe3e7b0c719587ed6d7197ea132e5636425befe3a6951e99b896a1d8fc3a"
    sha256 cellar: :any_skip_relocation, ventura:        "98ca013bc60ca9b658702f4e214d91bf1f74eae1052a36d2936cdf8523acc696"
    sha256 cellar: :any_skip_relocation, monterey:       "aa016db34206e6de048732692a5bdc81018fa7943610704980c23d77ef681857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8dc866125bf66ecf21d093cc9215f406ab0e575263aad9885b8d8c534e27094"
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
