class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.11.4.tar.gz"
  sha256 "7d3c567b38e0c38807aedbc63fb0840db68ab08a8aeeb57a719c77f579baf538"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63591c0b2d1c58407fa48f7cc9ef301a034f8f31ad700fb2bd59123b42ac2606"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f8e16f1750b299531f8af4bac1185bd2f3d9d1ba79c723a4b505547b44587ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fb59e16b35c89c3bbeed5873552284ca7af0fc9275a8bfe62e71431ef8b89a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "21ed68920d4f87776d7e68da851846f014f43e65767a8cea6cb9e7ea81f373d5"
    sha256 cellar: :any,                 arm64_linux:   "cde3301fc8726d5222ab878552a30f36b6de9f32e2d3cd7f519d0fc76bb10758"
    sha256 cellar: :any,                 x86_64_linux:  "1c5d62019809a44024f5631e5448826e288bc1f7c0870fcfe56a85e9d70ea505"
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

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/chronograf"
    system "go", "build", *std_go_args(ldflags:, output: bin/"chronoctl"), "./cmd/chronoctl"
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
