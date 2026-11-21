class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.12.3",
      revision: "51f4ac865b8670e0d3555ae992639ec05ecc334e"
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
    manifest_sha256 "4a60a1173593fe4e6c64711497efd14e9604914619f1664002737237da5b2e26"
    sha256 cellar: :any, arm64_golden_gate: "5504274b88313cab0b10865f143d8433bf0bb1e0e3cba83ec5f73717f7fe23f2"
    sha256 cellar: :any, arm64_tahoe:       "a36de877779610f8b09906842609ac6561a840ef32536f7ae7ad1ddb5bb3e257"
    sha256 cellar: :any, arm64_sequoia:     "f395a67592c924de3103f90b70d3fe07d85802872f6e508a43ef59d856274ff7"
    sha256 cellar: :any, arm64_linux:       "996c86bf5beeba42d33f6a9f2bf167d7d2a6f169396632c1a9316f6178f1f4bc"
    sha256 cellar: :any, x86_64_linux:      "17e922a9799cdf28cb679c2be76f523186a6c3a3e910899bb47c5e737afd25ab"
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
