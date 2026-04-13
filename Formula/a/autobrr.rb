class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.76.0.tar.gz"
  sha256 "b6a53d7c1f9e7ebf2603476f46f3a9c590122963d0eb024d58608b82ff8095bb"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bd4bb271fad0bd5e365364523a6ba61cba2ddf987da5612b1d15ebe689200f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "449b00b68dc2250d0cc385e365463cb7c11a1710f843c2f747e60527c8d464f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8570971cf52e2cb82c7b4a655312d219d171872c5e95f45473bc2d0ed946dd5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4278a09b2574de8f893513ea363fa9c194ed2830ef4049327b381c3ad17cf6ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4c21d0cd19be74deb2916fbddf1fcfe7eef4fc8a1711bb4433e15b455b4b07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d4af245e05abfc99ab20922b7b25f0894011ef1f33234020fbe068ead1728cf"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"

    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = spawn bin/"autobrr", "--config", testpath/""
    begin
      sleep 4
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
