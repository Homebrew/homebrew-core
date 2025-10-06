class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.3.tar.gz"
  sha256 "3ba69aa7e7af86f0e23230059bfbb01856c5c8b0bece2ec828e31afbe8be687c"
  license "MIT"

  depends_on "go" => :build
  def install
    build_date = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    commit = "4a10cfacc3446ed1bbd6e79639957d0cd650db2e"
    default_config = etc/"cliproxyapi.conf"
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{commit} -X main.BuildDate=#{build_date} -X main.DefaultConfigPath=#{default_config}"

    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/server/main.go"
    etc.install "config.example.yaml" => "cliproxyapi.conf"
  end

  service do
    run [opt_bin/"cliproxyapi"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cliproxyapi --help 2>&1")
  end
end
