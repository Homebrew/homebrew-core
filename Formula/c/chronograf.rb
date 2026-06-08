class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.11.3.tar.gz"
  sha256 "63415015fa28c0f0ae751c34cc0044382e208279a46658a313a2a6fa41166605"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39a024f7f0cad081864a828f1ede1aedc829254b53dda4ff08d86990ed13dea3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90240e1dcd0a50fffe50cd6fd629e5bc9b7bf29c148e797b49573e734ce166dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "869b974b8ed35d6cf3c3b7aa008a88a8acd1f764affcbbc00df28d5ca280ff40"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3b33d1fdb09bcfd820d31915bb471e54a228505cd3b4e370da68096d58524aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "706ad899c0d8eaaf72ce0f532347c128680760ecb75ffff8f798f979d591381e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f813527615b4ee2b6b9833fa9370bd33407f00368b317261dba4f485107fcfb4"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkg-config-wrapper" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    ENV["PKG_CONFIG"] = Formula["pkg-config-wrapper"].opt_bin/"pkg-config-wrapper"
    ENV["CGO_ENABLED"] = "1" if OS.linux?
    ENV["npm_config_build_from_source"] = "true"

    system "yarn", "--cwd=ui", "install"
    system "yarn", "--cwd=ui", "build", "--no-cache"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/chronograf"
    system "go", "build", *std_go_args(ldflags:, output: bin/"chronoctl"), "./cmd/chronoctl"
  end

  service do
    run opt_bin/"chronograf"
    keep_alive true
    error_log_path var/"log/chronograf.log"
    log_path var/"log/chronograf.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chronograf --version")

    port = free_port
    pid = spawn bin/"chronograf", "--port=#{port}"
    output = shell_output("curl -s --retry 5 --retry-connrefused 0.0.0.0:#{port}/chronograf/v1/")
    assert_match "/chronograf/v1/layouts", output
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
