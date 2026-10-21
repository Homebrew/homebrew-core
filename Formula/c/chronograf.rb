class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.11.6.tar.gz"
  sha256 "00756bde5e5a1b9e1201d93d4c5c3558cb3cf16d914acf9f8fa8165be7e30a55"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49ab86506a78abb26b9de14e363c69f64f9ff71526921fe0ffa7d010ccad288d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fce5f5a970ce30ff2c402a606924879dd1477400ebfcb8290631c62a3c50fed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5eacced2ff40b0b4cfefd17d356c83e59e5b28fe0de970ee81b05d450a8b7901"
    sha256 cellar: :any,                 arm64_linux:       "4957f37818aee615b6255e5df37f467adfc4618caddad8158a623fcaae688bef"
    sha256 cellar: :any,                 x86_64_linux:      "9753efa4dc62d36f5725f21de64b31f3ea14f8638b96e9d2903d28af732d1e81"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkg-config-wrapper" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    ENV["PKG_CONFIG"] = formula_opt_bin("pkg-config-wrapper")/"pkg-config-wrapper"
    ENV["CGO_ENABLED"] = "1" if OS.linux?
    ENV["npm_config_build_from_source"] = "true"

    system "yarn", "--cwd=ui", "install"
    system "yarn", "--cwd=ui", "build", "--no-cache"

    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/chronograf"
    system "go", "build", *std_go_args(ldflags: :goreleaser, output: bin/"chronoctl"), "./cmd/chronoctl"
  end

  service do
    run opt_bin/"chronograf"
    keep_alive true
    error_log_path var/"log/chronograf.log"
    log_path var/"log/chronograf.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chronograf --version")

    port = free_port
    pid = spawn bin/"chronograf", "--port=#{port}"
    output = shell_output("curl -s --retry 5 --retry-connrefused 0.0.0.0:#{port}/chronograf/v1/")
    assert_match "/chronograf/v1/layouts", output
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
