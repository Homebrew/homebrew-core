class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.11.1.tar.gz"
  sha256 "aaa17b75e192f9d14709223c1070db81f382447afded69c5cbbb8be417229fb8"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5b70280c4f201b7b04b71d7667d46ee2321ba0510c2472bf75fdde51af6f65b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d40c11f04b3135055191360c58cf7a4691a375593e99c12114efa8cd309c2e70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de66f5a7aea8d9849b169298afb4c2e71ebca45e4b4e829ae78228a312b66881"
    sha256 cellar: :any_skip_relocation, sonoma:        "3af85f1489c43441dcbb1e7a46b6a0b1c1e7fcefef574f27a8df2f7caf47b313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6acd0982f8cf4f58babf785eb92bc09053fd80cbffa98c41cc4155e69d687a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eafe31d39f938c140843c1c4ac98777668d551678388f3ba5be36e1936f15405"
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
