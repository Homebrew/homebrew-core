class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  license "MIT"
  head "https://github.com/influxdata/kapacitor.git", branch: "master"

  stable do
    url "https://github.com/influxdata/kapacitor.git",
        tag:      "v1.7.4",
        revision: "3470f6ae7f53acaca90459cc1128298548fdc740"

    # build patch to upgrade flux so that it can be built with rust 1.72.0+
    # upstream PR ref, https://github.com/influxdata/kapacitor/pull/2811
    patch do
      url "https://github.com/influxdata/kapacitor/commit/1bc086f38b5164813c0f5b0989045bd21d543377.patch?full_index=1"
      sha256 "38ab4f97dfed87cde492c0f1de372dc6563bcdda10741cace7a99f8d3ab777b6"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18df0fe28a2f236b9e83280d13fb1628da163b43010b1ab2e278d596be334154"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fc56e944c7205bf82e6f09e0fd6acb2671813abff062cb5358c3e10aa34240b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "077bb8e7923a28559b7fca1bf0e5da9a5bed8cbc2ec066292145e0ea0b61edb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "7320249f7bfd73fc7e9d1bfde2a14aa6e6800981c72b67cfeaf97023b7f8b7dc"
    sha256 cellar: :any_skip_relocation, ventura:        "fc0aea1281480c4dc679d6edf1b2ac03918db4ad774adcd8160f07f05370abdd"
    sha256 cellar: :any_skip_relocation, monterey:       "46a38f00666300e465230a0f8330c9d6e44758dd2bc4b9475c8bc8e0770f3cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6007b9e8d7e2b33e36510923d1989d83ef86e36e724c118686cdd61ef32d38a1"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build # for `pkg-config-wrapper`
  end

  # NOTE: The version here is specified in the go.mod of kapacitor.
  # If you're upgrading to a newer kapacitor version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.12.tar.gz"
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
