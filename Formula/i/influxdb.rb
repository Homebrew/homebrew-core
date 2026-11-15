class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.12.2",
      revision: "cc9769917ab399ed5b48567a92b5d34ed4d918ea"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/influxdata/influxdb.git", branch: "main"

  # Upstream no longer creates releases for tags on GitHub, so we check the
  # version in the install script instead.
  livecheck do
    url "https://www.influxdata.com/d/install_influxdb3.sh"
    regex(/^INFLUXDB_OSS_VERSION=["']v?(\d+(?:\.\d+)+)["']$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bf0d0a438df8a6e8031b4be30edda0da413156785bcf665db733e22fb86b1063"
    sha256 cellar: :any, arm64_tahoe:       "4282ad6ff2919791ddc7e056dfb5306d26cef7a819a4ae9a095987d25a2d521a"
    sha256 cellar: :any, arm64_sequoia:     "1c23dfb3c9eed7d644064f9e2ee7b158469fff9b41d5f48897f2a2527c294952"
    sha256 cellar: :any, arm64_linux:       "78b0c577759548fe420830634d6eb2708b5da163de352c46df6d5144fb1b88a5"
    sha256 cellar: :any, x86_64_linux:      "6b1cc4fa8aa460857ffcc172127abe4b086c09287844fed3fa3f46c2ec319dd0"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "python@3.15"

  uses_from_macos "bzip2"

  def install
    ENV["PYO3_PYTHON"] = python3
    ENV["PYTHON_SYS_EXECUTABLE"] = python3

    # Remove local development overrides which isn't used in upstream CI
    rm ".cargo/config.toml"

    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux

    system "cargo", "install", *std_cargo_args(path: "influxdb3")
  end

  service do
    run [opt_bin/"influxdb3", "serve"]
    keep_alive true
    working_dir var
    environment_variables INFLUXDB3_NODE_ID:      "default",
                          INFLUXDB3_OBJECT_STORE: "file",
                          INFLUXDB3_DATA_DIR:     var/"lib/influxdb"
    log_path var/"log/influxdb/influxdb3.log"
    error_log_path var/"log/influxdb/influxdb3.log"
  end

  test do
    port = free_port
    host = "http://localhost:#{port}"
    pid = spawn bin/"influxdb3", "serve",
                          "--node-id", "node1",
                          "--object-store", "file",
                          "--data-dir", testpath/"influxdb_data",
                          "--http-bind", "0.0.0.0:#{port}"

    sleep 5

    curl_output = shell_output("curl --silent --head #{host}")
    assert_match "401 Unauthorized", curl_output
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
