class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  url "https://github.com/influxdata/kapacitor.git",
      tag:      "v1.8.9",
      revision: "acdeb951399e424437df095eea22d71422df8dd0"
  license "MIT"
  compatibility_version 1
  head "https://github.com/influxdata/kapacitor.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69be42df44208979c89ab5757af10b71686458acfa99bfd59ef423de21956fab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2428a28404fb19f38d9668ce56501c99070a200570d53cb61a29263f12a86c5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "37cc0a50deff63ee105d9311dae6f783c637f00ea3431db6c094a4de8839f101"
    sha256 cellar: :any,                 arm64_linux:       "dbaad8fab63e85890dc9fb3ef8b93c1ec2b8b004328e20133687a0dea5a111b9"
    sha256 cellar: :any,                 x86_64_linux:      "6c65c502838dbc554f3c7092fda9c920620aaad0d161e8caa584642f3153bd10"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build # for `pkg-config-wrapper`
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of kapacitor.
  # If you're upgrading to a newer kapacitor version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.3.1.tar.gz"
    sha256 "11776c4f44b4d338619723cba1a6ef716573e80a358b0943ff2e2a86129ca8d5"

    livecheck do
      url "https://raw.githubusercontent.com/influxdata/kapacitor/v#{LATEST_VERSION}/go.mod"
      regex(/pkg-config\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  # `test do` block runs a local kapacitord server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    resource("pkg-config-wrapper").stage do
      system "go", "mod", "download"
    end
    # `pkg-config-wrapper` drives a cargo build of libflux inside the `flux`
    # Go module during `install`; warm the cargo cache for it here.
    flux_dir = Utils.safe_popen_read("go", "list", "-m", "-f", "{{.Dir}}", "github.com/influxdata/flux").chomp
    system "cargo", "fetch", "--manifest-path", "#{flux_dir}/libflux/Cargo.toml", *std_cargo_fetch_args
  end

  def install
    # `flux-core` Workaround for `error: hiding a lifetime that's elided elsewhere is confusing` with `rust` 1.89+
    ENV.append_to_rustflags "--allow dead_code --allow mismatched_lifetime_syntaxes"
    # `flux` Workaround for `error: private item shadows public glob re-export`
    ENV.append_to_rustflags "--allow hidden_glob_reexports"
    # `flux` Workaround for `error: value assigned to `<varname>` is never read`
    ENV.append_to_rustflags "--allow unused_assignments"
    # `flux` Workaround for `error: use of deprecated associated function` with `rust` 1.99+
    ENV.append_to_rustflags "--allow deprecated"

    # Workaround to avoid patchelf corruption when cgo is required (for flux)
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/kapacitor"
    system "go", "build", *std_go_args(ldflags: :goreleaser, output: bin/"kapacitord"), "./cmd/kapacitord"

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
