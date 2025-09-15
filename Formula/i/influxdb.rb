class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.4.2",
      revision: "571299afed3644c69811df9a71816446af64dec0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/influxdata/influxdb.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "416be7fb38774a10def2430255af879d6b4984fb8c2e854eb42bb67ad1a0a4f7"
    sha256 cellar: :any,                 arm64_sonoma:  "4a7e12857673b72901dc8b7c84be825307a0ca2a4efca7138bfe98bb5f239408"
    sha256 cellar: :any,                 arm64_ventura: "7b1e1b623ba3df946ec5f22670050521e53fe855a177baa86f84adb47e9eb843"
    sha256 cellar: :any,                 sonoma:        "cefb83b398867939665527a5ccac218f3de86c75b6d981b7ee85467617c4a7b1"
    sha256 cellar: :any,                 ventura:       "1e0e88a164a06638e6141eb6e9fc0612aeaaf3d58db0fcb039327aa461d98186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7be9eaef36f170a8df003fcba7922d0f8a388f1e7dee9e8d98adc9e5d03e8114"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "python@3.13"

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "lld" => :build
  end

  def install
    py = Formula["python@3.13"].opt_bin/"python3"
    ENV["PYO3_PYTHON"] = py
    ENV["PYTHON_SYS_EXECUTABLE"] = py

    # Configure rpath to locate Python framework at runtime
    if OS.mac?
      fwk_dir = Formula["python@3.13"].opt_frameworks/"Python3.framework/Versions/3.13"
      ENV.append "RUSTFLAGS", "-C link-arg=-Wl,-rpath,#{fwk_dir}"
    end

    system "cargo", "install", *std_cargo_args(path: "influxdb3")

    # Create data, plugin, and log directories
    (var/"lib/influxdb3").mkpath
    (var/"lib/influxdb3/plugins").mkpath
    (var/"log/influxdb3").mkpath
  end

  service do
    run [opt_bin/"influxdb3", "serve",
         "--node-id", "node0",
         "--object-store", "file",
         "--data-dir", var/"lib/influxdb3",
         "--plugin-dir", var/"lib/influxdb3/plugins"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/influxdb3/influxd_output.log"
    error_log_path var/"log/influxdb3/influxd_output.log"
  end

  test do
    port = free_port
    host = "http://localhost:#{port}"
    pid = spawn bin/"influxdb3", "serve",
                          "--node-id", "node0",
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
