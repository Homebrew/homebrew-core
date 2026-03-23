class Bounceback < Formula
  desc "Stealth redirector for red team operation security"
  homepage "https://github.com/D00Movenok/BounceBack"
  url "https://github.com/D00Movenok/BounceBack/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "47673a62ab5fdef6d1d34e5ce84b0f9faa0e481a50a0580276a2b89544d067f3"
  license "MIT"
  head "https://github.com/D00Movenok/BounceBack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7096c878b874f7954b658549c2498418a7bf5ca840ee6f8d0e28438269925c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7096c878b874f7954b658549c2498418a7bf5ca840ee6f8d0e28438269925c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7096c878b874f7954b658549c2498418a7bf5ca840ee6f8d0e28438269925c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "461ef1bbbee371072559282a90e6c41009f20b5f2c2411edf5cc77ec72100a19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73bc1080c0f6c4b689e82e5bf20ba1188d9eae00100dac6814d9f781e3652685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80740283f2ee9072d209356cf0d831b2ad37a4aa785a14cd93dda9891bf6e184"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bounceback"

    pkgshare.install "data"
    # update relative data path to homebrew pkg path
    inreplace "config.yml", " data", " #{pkgshare}/data"
    etc.install "config.yml" => "bounceback.yml"
  end

  service do
    run [opt_bin/"bounceback", "--config", etc/"bounceback.yml"]
    keep_alive true
    working_dir var
    log_path var/"log/bounceback.log"
    error_log_path var/"log/bounceback.log"
  end

  test do
    pid = spawn bin/"bounceback", "--config", etc/"bounceback.yml"
    sleep 2
    assert_match "\"message\":\"Starting proxies\"", (testpath/"bounceback.log").read
    assert_match version.to_s, shell_output("#{bin}/bounceback --help", 2)
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
