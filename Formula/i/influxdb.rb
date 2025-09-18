class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.4.0",
      revision: "9e26dadce59a3e453b80e8d2a9342da5bde3210a"
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
    sha256 cellar: :any,                 arm64_tahoe:   "b10852e16acbfb12c347020a1eb7c51b27492fc6bba48c4657678d7a3875d099"
    sha256 cellar: :any,                 arm64_sequoia: "251b2e5e5062197c33fc5c6ecf84d738c61b7ef7867fa31765144473c393b605"
    sha256 cellar: :any,                 arm64_sonoma:  "b8fbde9575e53107687390fab5bf88b9ebbdb139bba58944ef7edb99e5192b70"
    sha256 cellar: :any,                 arm64_ventura: "0ce4f55589ca17b33b09b0bd5288e673bac636716584009bb3bd61aeb68e3901"
    sha256 cellar: :any,                 sonoma:        "b423c21c66e35080ba59e3f5646fbbc09cee9ff7bc44457687316b45242c9cc8"
    sha256 cellar: :any,                 ventura:       "80e49708a33b6286d5c2801027de5f92438e9df0eff8c98b788fccedd061d28b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "471ea101ee4cbdf4d4bdb7a3542edaf2f5c15927cd928eda9106e72cfe1ed0ee"
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
