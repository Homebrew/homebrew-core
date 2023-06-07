class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  license "MIT"
  head "https://github.com/influxdata/kapacitor.git", branch: "master"

  stable do
    url "https://github.com/influxdata/kapacitor.git",
        tag:      "v1.6.6",
        revision: "79897085a4802304bb2fb052035bac4d16913302"

    # build patch to upgrade flux so that it can be built with rust 1.66.0
    # upstream bug report, https://github.com/influxdata/kapacitor/issues/2769
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/38549b7/kapacitor/1.6.6.patch"
      sha256 "32bba2e397d25afb7fed8128f5f924e0fd3368371b959b7ef2a68260f32110e4"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82a7eae9df12d924844d669cd098e4d2c627b6ddbe88b46a4fbb4a95f773ca05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "753eb96876f6b4ee37822cf96328b4bd52dd97300230384f145947ce92317b96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51d79f3c8df3812c2a2afa242d9b5d5e58463bd13845e4c6dca8bc1b8dc77213"
    sha256 cellar: :any_skip_relocation, ventura:        "62acbd5f2cd1f6178338868d5d1a2ff93c7a2a46f9bc569f4b5d3b9380f74426"
    sha256 cellar: :any_skip_relocation, monterey:       "8abe8b6727275b75d12fc5a014847ac2e882d2b2730f8fea6989197a68f46edd"
    sha256 cellar: :any_skip_relocation, big_sur:        "7778f76687401b5b649c3cd490b9b19aa97dbb6a72fe714084acec78680b38b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9c728517d5c4fd80f8e9dbe70813fa657ecc4314334cc452890967cfecb3efd"
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
      -s -w
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
