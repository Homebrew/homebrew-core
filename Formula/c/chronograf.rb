class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.11.5.tar.gz"
  sha256 "d8ad3f9ed113d4e44a48cb7459302bd0e011c0ed2117df2d4d4be1111f122362"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "843d554ccd56b327b0b20b7658535a169a937f89e10cc4c3d913bb5cb6a144c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "612ffb2386bc2b9658952ef1d8921e8fb7a0adba9d4437f23fcf581ac67f9848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c69246aaedf6f029f6e7b049a35a8d3a05abb3ed25204a78410827b1f3c3ae9f"
    sha256 cellar: :any,                 arm64_linux:       "b768015383266690169d9cec5793830ba9a56c0a431684612d9f3fac7faa226f"
    sha256 cellar: :any,                 x86_64_linux:      "39371f270c5773f94d43a7ad46d76c3853aa21adc4fe817922cd5e36754a615d"
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
