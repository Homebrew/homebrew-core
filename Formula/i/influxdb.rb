class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.3.0",
      revision: "02d7ee1e6fec5b62debbe862881562e451624de6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23d65d552476d6a5c9a10d741f202fead045809782f0eeb25ac146f92b6ae59f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a6b817054743d4ad428dc1f7b02a0b22b8f5c575173e3b2e8f16f6cfd9f7702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "402fdde18259f92fb63ae902a4c90619ff1ab3fdd6dd08961742b69906b05f7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f67c158257908b8c36ce0334d46eb7c43255fa27e126fa5f043153f3946fb95a"
    sha256 cellar: :any_skip_relocation, ventura:       "a716620cb960f36e308239eee5f7277f29070fb3e8e13246cea44e30c4ace5c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c5c653142f61b7a1abee3d66add075b163341e0908579a192a6217197e3853d"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "python@3.13"

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
  end

  service do
    run opt_bin/"influxdb3"
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/influxdb3/influxd_output.log"
    error_log_path var/"log/influxdb3/influxd_output.log"
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
