class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"

  license "MIT"
  head "https://github.com/influxdata/kapacitor.git", branch: "master"

  stable do
    url "https://github.com/influxdata/kapacitor.git",
        tag:      "v1.6.5",
        revision: "c6c917f3097573544574ae94b5ef955a15256772"

    # build patch to upgrade flux so that it can be built with rust 1.66.0
    # upstream PR, https://github.com/influxdata/kapacitor/pull/2738
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/58a8918/kapacitor/1.6.5-flux.patch"
      sha256 "6b03f69d4139ecfff128e7eac088b73b6b11ef395451e44ee33c2e7556661fa1"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62c05530b155bd534dcd90307e6b9a97fcd1362676445bc0be20742c9c84b6e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2d49decdd41316be57ddc4799601326dd6095e528166710f7bd2421481d524b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d6d31bb54ed021f254369a6049979320c140433c158e89d1f9bccd192b444e2"
    sha256 cellar: :any_skip_relocation, ventura:        "246319fc10189a78c5be006bb495bea5e7d12e0d9b38fd4d59d70fc630cfdd5a"
    sha256 cellar: :any_skip_relocation, monterey:       "20165171837847b780947b538d4c57b36ef5a666cd7d0ec8a1e7e402a189ad5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d410845651584e1963bf4d21fc273bc7af38a3c21eac2cb00cc06cbd9047697e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f15abe375947d818bb16a295faecdb42ee084dabc3b84b0d80af61935d602ab"
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
