class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  url "https://github.com/influxdata/kapacitor.git",
      tag:      "v1.8.6",
      revision: "ab88ca501f0ce0873dd837bee8643ef64f4d518b"
  license "MIT"
  head "https://github.com/influxdata/kapacitor.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c3bb986375c4e6ad9f6a2ff2f9bd2f4b9498037ce8dcac1386173ddebcd35a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "976a2f80f1773a2f7cf1fb0ba7070e306764deb43b7d2decef53185ed7b8016f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f2baf08a8efad92ac0ba6badf160dd7816a5017f218a6ec97d3f0ee0e1a1210"
    sha256 cellar: :any_skip_relocation, sonoma:        "49247f7c6d705941c141f864dbc946349d0c3b560b9a41e495e3e4d6386d67fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6d78e06c5a2426d6f9d40e2cccaed1d529d95c0266481d90e107eb07c800b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6561b70701cb82e1390bf52d2eaf674cdce8c8b529c3358f6cadababce7950e5"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build # for `pkg-config-wrapper`
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of kapacitor.
  # If you're upgrading to a newer kapacitor version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.12.tar.gz"
    sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"

    livecheck do
      url "https://raw.githubusercontent.com/influxdata/kapacitor/v#{LATEST_VERSION}/go.mod"
      regex(/pkg-config\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  def install
    # `flux-core` Workaround for `error: hiding a lifetime that's elided elsewhere is confusing` with `rust` 1.89+
    ENV.append_to_rustflags "--allow dead_code --allow mismatched_lifetime_syntaxes"
    # `flux` Workaround for `error: private item shadows public glob re-export`
    ENV.append_to_rustflags "--allow hidden_glob_reexports"
    # `flux` Workaround for `error: value assigned to `<varname>` is never read`
    ENV.append_to_rustflags "--allow unused_assignments"

    # Workaround to avoid patchelf corruption when cgo is required (for flux)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kapacitor"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kapacitord"), "./cmd/kapacitord"

    inreplace "etc/kapacitor/kapacitor.conf" do |s|
      s.gsub! "/var/lib/kapacitor", "#{var}/kapacitor"
      s.gsub! "/var/log/kapacitor", "#{var}/log"
    end

    etc.install "etc/kapacitor/kapacitor.conf"
    (var/"kapacitor/replay").mkpath
    (var/"kapacitor/tasks").mkpath
  end

  service do
    run [opt_bin/"kapacitord", "-config", etc/"kapacitor.conf"]
    keep_alive successful_exit: false
    error_log_path var/"log/kapacitor.log"
    log_path var/"log/kapacitor.log"
    working_dir var
  end

  test do
    (testpath/"config.toml").write shell_output("#{bin}/kapacitord config")

    inreplace testpath/"config.toml" do |s|
      s.gsub! "disable-subscriptions = false", "disable-subscriptions = true"
      s.gsub! %r{data_dir = "/.*/.kapacitor"}, "data_dir = \"#{testpath}/kapacitor\""
      s.gsub! %r{/.*/.kapacitor/replay}, testpath/"kapacitor/replay"
      s.gsub! %r{/.*/.kapacitor/tasks}, testpath/"kapacitor/tasks"
      s.gsub! %r{/.*/.kapacitor/kapacitor.db}, testpath/"kapacitor/kapacitor.db"
    end

    http_port = free_port
    ENV["KAPACITOR_URL"] = "http://localhost:#{http_port}"
    ENV["KAPACITOR_HTTP_BIND_ADDRESS"] = ":#{http_port}"
    ENV["KAPACITOR_INFLUXDB_0_ENABLED"] = "false"
    ENV["KAPACITOR_REPORTING_ENABLED"] = "false"

    begin
      pid = spawn "#{bin}/kapacitord -config #{testpath}/config.toml"
      sleep 20
      shell_output("#{bin}/kapacitor list tasks")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
