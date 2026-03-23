class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "ee12f7b5f97308708de5067deebb3d3322fc24f6d54f906a47a0a4e8db799122"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8abb85b3dc58e7bf0a9b9bf760dc4d69df91f75fc98fc2dc6e0bbe76048bb12d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8abb85b3dc58e7bf0a9b9bf760dc4d69df91f75fc98fc2dc6e0bbe76048bb12d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8abb85b3dc58e7bf0a9b9bf760dc4d69df91f75fc98fc2dc6e0bbe76048bb12d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c3268d60a7701aa29dbc018566ce82f76bfa95834c7f89e49376db86f885dfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e1ca5f23076ff3e926c75e3047185a14ab0299eed78c8f629d1eccd517b3993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cffea493223baee8129b6bb2ad21794b3426d0fee51e709706f6dc51415134a"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/refs/tags/v0.4.5.tar.gz"
    sha256 "53c6a9e29965aaf19210ac6470935537040e782101057a199098feb33c2674f8"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmd/xcaddy/main.go", "build", revision, "--output", bin/"caddy"
    end

    generate_completions_from_executable("go", "run", "cmd/caddy/main.go", "completion")

    system bin/"caddy", "manpage", "--directory", buildpath/"man"

    man8.install Dir[buildpath/"man/*.8"]
  end

  def caveats
    <<~EOS
      When running the provided service, caddy's data dir will be set as
        `#{HOMEBREW_PREFIX}/var/lib`
        instead of the default location found at https://caddyserver.com/docs/conventions#data-directory
    EOS
  end

  service do
    run [opt_bin/"caddy", "run", "--config", etc/"Caddyfile"]
    keep_alive true
    error_log_path var/"log/caddy.log"
    log_path var/"log/caddy.log"
    environment_variables(
      XDG_DATA_HOME: "#{HOMEBREW_PREFIX}/var/lib",
      HOME:          "#{HOMEBREW_PREFIX}/var/lib",
    )
  end

  test do
    port1 = free_port
    port2 = free_port

    (testpath/"Caddyfile").write <<~EOS
      {
        admin 127.0.0.1:#{port1}
      }

      http://127.0.0.1:#{port2} {
        respond "Hello, Caddy!"
      }
    EOS

    fork do
      exec bin/"caddy", "run", "--config", testpath/"Caddyfile"
    end
    sleep 2

    assert_match "\":#{port2}\"",
      shell_output("curl -s http://127.0.0.1:#{port1}/config/apps/http/servers/srv0/listen/0")
    assert_match "Hello, Caddy!", shell_output("curl -s http://127.0.0.1:#{port2}")

    assert_match version.to_s, shell_output("#{bin}/caddy version")
  end
end
