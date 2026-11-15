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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "5d70e8fb679351a6a30574d045bbeacfce84fd5c336b5073a31a70737ed48d95"
    sha256 cellar: :any, arm64_tahoe:       "d8394147a6d110aecb8220f7949d7ff5d8bf3e22ebc3cdb080fbf2c65c8ed656"
    sha256 cellar: :any, arm64_sequoia:     "695ed1ea168cbaf4f30a2475561ec4d823bbcd1238fbce3429c5e2ca0f273740"
    sha256 cellar: :any, arm64_linux:       "a624e087b9e377d8ca6795abca559cb3b5ab07008f2d7760bb89af3f9871d815"
    sha256 cellar: :any, x86_64_linux:      "5b1aa88793ac868b27c344bbb203ec7f919e5d0771d995418f943f92aeee579a"
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
