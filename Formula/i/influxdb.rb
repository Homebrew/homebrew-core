class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.9.3",
      revision: "e8cd4f7262c40eea9702ae97870480fdfdd76fa1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/influxdata/influxdb.git", branch: "main"

  # Upstream no longer creates releases for tags on GitHub, so we check the
  # version in the install script instead.
  livecheck do
    url "https://www.influxdata.com/d/install_influxdb3.sh"
    regex(/^INFLUXDB_OSS_VERSION=["']v?(\d+(?:\.\d+)+)["']$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "80b23321765feea82c38b841429a4992c382b49f0f34859c16a585112d6c208e"
    sha256 cellar: :any, arm64_sequoia: "57594735aad24f352d366ae322f92787fff91fb21c32dba52a3349c4cd9f81b5"
    sha256 cellar: :any, arm64_sonoma:  "b3543c34023b77cb926b09170cfe25eb252d97bdc4ac9c841621d9b0a9065bbe"
    sha256 cellar: :any, sonoma:        "cfdb89f3062d1a10680450c12aa2e07126e05e0c6b32d64c0a6e67ffd916357a"
    sha256 cellar: :any, arm64_linux:   "344204753dcd0e6407741e05410aa40408d84e69b77a4b06d5c63f7271dd0c0c"
    sha256 cellar: :any, x86_64_linux:  "1c0269abbd883238d372a1bc6904c9216c2a622c1f67a17fba94f23c3be4069c"
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
