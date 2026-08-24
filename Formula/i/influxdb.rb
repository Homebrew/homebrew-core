class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.11.2",
      revision: "617521dc01dfed78a1e70185f80e55e027fd48de"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/influxdata/influxdb.git", branch: "main"

  # Upstream no longer creates releases for tags on GitHub, so we check the
  # version in the install script instead.
  livecheck do
    url "https://www.influxdata.com/d/install_influxdb3.sh"
    regex(/^INFLUXDB_OSS_VERSION=["']v?(\d+(?:\.\d+)+)["']$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b0b3e930525227aaf39f6184836df1aa17eb1f0c58d1664631db8fdff7d3ec1c"
    sha256 cellar: :any, arm64_sequoia: "7c5dfcbedb055d00bd7090226280c9f2b9d454a62eb18ce927923a6f40086a99"
    sha256 cellar: :any, arm64_sonoma:  "a1a04e5d2a9e9e342f76ea0f47e63ea7316e552d06896f6392445e242855e503"
    sha256 cellar: :any, sonoma:        "63ec53bba63f69096ac376ef06615b947416d796fb225c06bfb36aecdbba10a3"
    sha256 cellar: :any, arm64_linux:   "42d27f6305803bcda8b7645e36a36e028adf016cae9d5989760708894e0109b3"
    sha256 cellar: :any, x86_64_linux:  "49b6bd43b6ed01b7b5ff3d02c315502b425c83b909bfc131aa2769560e5a55d1"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "python@3.14"

  uses_from_macos "bzip2"

  def install
    python3 = which("python3.14")
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
    run [
      opt_bin/"influxdb3",
      "serve",
      "--node-id", "default",
      "--object-store", "file",
      "--data-dir", var/"lib/influxdb"
    ]
    keep_alive true
    working_dir var
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
    sleep 5 if OS.mac? && Hardware::CPU.intel?

    curl_output = shell_output("curl --silent --head #{host}")
    assert_match "401 Unauthorized", curl_output
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
