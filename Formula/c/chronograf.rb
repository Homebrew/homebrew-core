class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.11.7.tar.gz"
  sha256 "06c3edd7cae1ab8668fff6cc723695b6929bdca37a290cd959a2be455946f626"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "888b6b9ee5f8545725cd44ffbd1296e067a3f69bdef1e0596d9db23be235f0cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a192fd1f374dfec43c00eda22fe215ac89f808973c8f88b6118a64555f8203db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5e48d7b352285953ccbf99c1ff03de52465d2d41c68d45df7f5924a99f4f9fb3"
    sha256 cellar: :any,                 arm64_linux:       "241b8e968d6d916f5800b191508f8aa8cccdf09581650803fe0b0335bc8e82c5"
    sha256 cellar: :any,                 x86_64_linux:      "54fa7696c8a6b88a5d2fb6c3d56f5c8a2bae64ab2bd32f519878eb3d7f12b825"
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
