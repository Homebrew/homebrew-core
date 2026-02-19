class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.25.4/gitea-src-1.25.4.tar.gz"
  sha256 "2c067547343c5c0763d3370d82c81ef4c6e511fe342b300e5a687f664f3b405e"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaf09624f8a1717d181901dfcfe6684e157815270d645398a109eee2470f221c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c20a38a124dacfb5b56a362ed025471072800b7354e5951d3f006861669af66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "545623b3023a5d1774b11723f5172b69802dc8f71256cbbe32666053147eb961"
    sha256 cellar: :any_skip_relocation, sonoma:        "d074cadeec6acb06bd0a0920794bc0089fe4113ced998975d8a27846a0714a70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7d4f35526e149ef43447724df39701567354b7c62b4e8d8f57a086fe3e12e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66962be9ec44dbd317637b8eb0ffc79276c721230372c3c17bc209860e740aa9"
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
