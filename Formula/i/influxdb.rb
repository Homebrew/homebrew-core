class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.10.5",
      revision: "df21654049f722778ada5a12525254dd60e9b291"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/influxdata/influxdb.git", branch: "main"

  # Upstream no longer creates releases for tags on GitHub, so we check the
  # version in the install script instead.
  livecheck do
    url "https://www.influxdata.com/d/install_influxdb3.sh"
    regex(/^INFLUXDB_OSS_VERSION=["']v?(\d+(?:\.\d+)+)["']$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ccc7ee6bcff3433743404baa4a5f4ca5c6765b9b14d6008d1433a45f0363c1ba"
    sha256 cellar: :any, arm64_sequoia: "b03f4538f475f720f575550b7fd3d64accab4d0abec031daf2615a58c357acda"
    sha256 cellar: :any, arm64_sonoma:  "3b33a95d7fdc5d74a0dfea939af568f4df4df6223eb583cfaf0ff328ddc346a8"
    sha256 cellar: :any, sonoma:        "61439f144e1ae0910784ebc6027c4521c4bd135864ad8ec1181b497103a00e08"
    sha256 cellar: :any, arm64_linux:   "060e4562931151cc373d3680cbf9688bca3e1bbea4afeecad028d24029758196"
    sha256 cellar: :any, x86_64_linux:  "5e2d071d0aa717d116513f561ae5b5536ba874856d692b333f5441992819dc82"
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
