class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.11.0.tar.gz"
  sha256 "11e1228f3b193d7b9cafad6ff4903f0f920a03432c5045ee620c105e361ced10"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91cd22b2b6b8793e72f37916d451fe1fd7c89cab46bce1de95c6d27045fe84f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d9eb5a49b5d262d5ca7fd0558a59f0b96e403d4f5bf9a71436fbdd15d3573fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76a9fa0bad678e7e38c7bad9ca6dc3479f9102376eb3b6aacd39d57bbef2d484"
    sha256 cellar: :any_skip_relocation, sonoma:        "b205bc5e83253166087d3895ba61466bbb6d0a30a96be3a041907bf03b0a8fcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "154313920e25dc36c56c26aa567af0753f3092949f7d6b4a497e671808deea56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e5b01f1a9c61c9acbae2b41a803c5e7cd7c471cab324ae399fcbaf3c895741d"
  end

  depends_on "go" => :build
  # Avoid C++20 from Node 23+ until "@parcel/watcher >= 2.2.0" for "node-addon-api >= 4"
  # Issue ref: https://github.com/nodejs/node-addon-api/issues/1007
  depends_on "node@22" => :build
  depends_on "pkg-config-wrapper" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV["npm_config_build_from_source"] = "true"
    ENV["PKG_CONFIG"] = Formula["pkg-config-wrapper"].opt_bin/"pkg-config-wrapper"

    system "yarn", "--cwd=ui", "install"
    system "yarn", "--cwd=ui", "build"

    ldflags = "-s -w -X main.version=#{version}"
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
