class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.8.0",
      revision: "5276213d5babe4441466a1117d0037909b26d1c7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/influxdata/influxdb.git", branch: "main"

  # Upstream no longer creates releases for tags on GitHub, so we check the
  # version in the install script instead.
  livecheck do
    url "https://www.influxdata.com/d/install_influxdb3.sh"
    regex(/^INFLUXDB_VERSION=["']v?(\d+(?:\.\d+)+)["']$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc4de6aacb802812ca0540c9b88c7aa92943ed380f1d54de777097b290013675"
    sha256 cellar: :any,                 arm64_sequoia: "1ddf054f8f2d59b24f9df41110b759d0940e3d59e70c9b17d9b2422c21290eb7"
    sha256 cellar: :any,                 arm64_sonoma:  "50c11bc6b121a7c6432ad6771e9a18d4a789af76435e21f42a52a38a8d1e7b6e"
    sha256 cellar: :any,                 sonoma:        "b008bc2785334484e305ef06a3488d1c5f147f24d4b677db67ed0cd32403f6b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a571ab02efb289ee9379e898568ed0383fb581d61216d8f8961b29880bc5ddce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb476c55c303af76239deae6ed5f5afbdee934024d5fedb9719b15fae7daffbc"
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
