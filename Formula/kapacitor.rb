class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  url "https://github.com/influxdata/kapacitor.git",
      tag:      "v1.6.5",
      revision: "c6c917f3097573544574ae94b5ef955a15256772"
  license "MIT"
  head "https://github.com/influxdata/kapacitor.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e40884fc0f9453623c7acb5775d2e63500d81549f123fb2a48ac56a6534a31ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "270cac65a587f1d9be201f73951c905cca220b7f7ce807f1e17e0ad80668af66"
    sha256 cellar: :any_skip_relocation, monterey:       "dc5738e2c215096b421ee41f7db720be7362fc3a7c0ee2f47e575a2e86f6a608"
    sha256 cellar: :any_skip_relocation, big_sur:        "454fdcd9e6221286fb3b18a190ff01aed837d34c4748889c052189dbf4ad65ba"
    sha256 cellar: :any_skip_relocation, catalina:       "f2f53c7ef7208fa54647a40531796db0c81ce672601ddff540e8d228f99169de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ed7adfefaa20584664fcef3e78c321adee86c99c1a8057c8ba22e21cc1d6390"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build # for `pkg-config-wrapper`
  end

  # NOTE: The version here is specified in the go.mod of kapacitor.
  # If you're upgrading to a newer kapacitor version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/v0.2.12.tar.gz"
    sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"
  end

  def install
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/kapacitor"
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "-o", bin/"kapacitord", "./cmd/kapacitord"

    inreplace "etc/kapacitor/kapacitor.conf" do |s|
      s.gsub! "/var/lib/kapacitor", "#{var}/kapacitor"
      s.gsub! "/var/log/kapacitor", "#{var}/log"
    end

    etc.install "etc/kapacitor/kapacitor.conf" => "kapacitor.conf"
  end

  def post_install
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
      s.gsub! %r{/.*/.kapacitor/replay}, "#{testpath}/kapacitor/replay"
      s.gsub! %r{/.*/.kapacitor/tasks}, "#{testpath}/kapacitor/tasks"
      s.gsub! %r{/.*/.kapacitor/kapacitor.db}, "#{testpath}/kapacitor/kapacitor.db"
    end

    http_port = free_port
    ENV["KAPACITOR_URL"] = "http://localhost:#{http_port}"
    ENV["KAPACITOR_HTTP_BIND_ADDRESS"] = ":#{http_port}"
    ENV["KAPACITOR_INFLUXDB_0_ENABLED"] = "false"
    ENV["KAPACITOR_REPORTING_ENABLED"] = "false"

    begin
      pid = fork do
        exec "#{bin}/kapacitord -config #{testpath}/config.toml"
      end
      sleep 20
      shell_output("#{bin}/kapacitor list tasks")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
