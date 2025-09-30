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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "76a35e5f711f46d0f205f5a4e392154cfa04dd3d3b68441e81d8a9ec6d790522"
    sha256 cellar: :any,                 arm64_sequoia: "741206932e2e625db4bceabf409fde90106b35cab787fee113aa3d61cac25112"
    sha256 cellar: :any,                 arm64_sonoma:  "00012928fc8096db1f566a444188fd2728f7c2e034d03acfdad36f4a6f196afe"
    sha256 cellar: :any,                 sonoma:        "fc709d2eae34adb07ae878c4f94800ff28e4c1dc22f92b1f03cfb86e3545c894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a699da6b82efe3bd8c83094fff0a3f63c5b7014e5e26dc4d8698327bad357286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e51586615ec61fc1bd4af814f2462f7175762393964fd4b034b6fe438b2a4cf"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "python@3.13"

  uses_from_macos "bzip2"

  on_linux do
    on_intel do
      depends_on "lld" => :build
    end
  end

  def install
    python3 = which("python3.13")
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
