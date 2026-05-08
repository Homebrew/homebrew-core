class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.11.2.tar.gz"
  sha256 "5bee300f2466d6a19774644993e9802ca93d18c5571099a4fb965daa47339710"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb2474203dd02216655dbbf45e8175709b52b1a16c3f44e7e675907fac265e2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a589e354fb36b0f6d2b93c48f7d74d5b678ed905d664925763f0914b41f587d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5af5c8d23f2fcdbd76db708d4c571cb89d88e2172283c7a22360c4a08ad6e8e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e43f18ce274e49bbc1c0591278e286f00981698ce64b1745536e12f7766bbfd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39371de12b393bd0350bae13ff2318d3ead6f76fbe4d338530c6e1f517c1cbd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a26e7c986c4839ee9f934be7a9cf4e6d9b5fdd1964bcd79280245661cffbed"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build
  depends_on "pkg-config-wrapper" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    ENV["PKG_CONFIG"] = Formula["pkg-config-wrapper"].opt_bin/"pkg-config-wrapper"

    ENV["CGO_ENABLED"] = "1" if OS.linux?

    ENV["npm_config_build_from_source"] = "true"

    system "yarn", "--cwd=ui", "install"
    system "yarn", "--cwd=ui", "build", "--no-cache"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/chronograf/main.go"
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
    sleep 10
    output = shell_output("curl -s 0.0.0.0:#{port}/chronograf/v1/")
    sleep 1
    assert_match "/chronograf/v1/layouts", output
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
