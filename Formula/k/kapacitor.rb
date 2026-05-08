class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  url "https://github.com/influxdata/kapacitor.git",
      tag:      "v1.8.5",
      revision: "1632cc16b34166a05dd52cd9dc718ad68cceab23"
  license "MIT"
  head "https://github.com/influxdata/kapacitor.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d224352807131ce89f62bf9740760ec49fbb0cae0280e5afe70251486eeedce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "000605ad433ea143cfcfe8b5de1a80c346150d4229b062f34900e6f23d6c7420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c97bff7206f356ab78d642d61eb40c9fb3661f3a3998820f5ca662292d44298"
    sha256 cellar: :any_skip_relocation, sonoma:        "486e54a5d48b284e22ee733162e805084b3acb49b04da858e67549a79ef7d720"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bc2dd3cae02273c9b1ffe58a31367cd3091b554aca21946b1c7e8f09ea9ca0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2f966ba0e9e731b6cf061e0dce29591b5dc1f28396d0aca903b877a2132fdb5"
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
