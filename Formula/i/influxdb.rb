class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.8.3",
      revision: "73f689bb31d5ca13c4f950fefb40d5f6e6163019"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/influxdata/influxdb.git", branch: "main"

  # Upstream no longer creates releases for tags on GitHub, so we check the
  # version in the install script instead.
  livecheck do
    url "https://www.influxdata.com/d/install_influxdb3.sh"
    regex(/^INFLUXDB_VERSION=["']v?(\d+(?:\.\d+)+)["']$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9a8c8dc7d8c743e5c5dd8328ef482bf92c4b862a94307fcc6a422170c027d88"
    sha256 cellar: :any,                 arm64_sequoia: "9989f3b5c32d501341a5ebcff4e2517bd87c87b6140de7767dd37a9b4c74582c"
    sha256 cellar: :any,                 arm64_sonoma:  "7116f4d542cfc9aabd21056356f04839e7d1b3d4692acb32c082f8e878eb8f1b"
    sha256 cellar: :any,                 sonoma:        "0bdd5b3b9d68e1fe85e14080dfdbf5fcf7e86e69bd0704fa657297de2c8e570a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6471a254035e432890393bcf29020f4842887346a117838a406308b69911a2c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acb4a0113469c90bd15a95407a66c914874fad6c9ba6fef379655be62795218f"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "python@3.14"

  uses_from_macos "bzip2"

  on_linux do
    on_intel do
      depends_on "lld" => :build
    end
  end

  def install
    python3 = which("python3.14")
    ENV["PYO3_PYTHON"] = python3
    ENV["PYTHON_SYS_EXECUTABLE"] = python3

    # Avoid upstream's default of Haswell and instead let superenv set this
    inreplace ".cargo/config.toml", '"-C", "target-cpu=haswell",', ""

    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux

    system "cargo", "install", *std_cargo_args(path: "influxdb3")
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
