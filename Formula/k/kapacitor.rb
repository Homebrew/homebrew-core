class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  license "MIT"
  head "https://github.com/influxdata/kapacitor.git", branch: "master"

  stable do
    url "https://github.com/influxdata/kapacitor.git",
        tag:      "v1.7.6",
        revision: "3347c7d9aec8e031a3eb05f501461fb106c20529"

    # TODO: Remove when release uses flux >= 0.195.0 to get following fix for rust >= 1.78
    # Ref: https://github.com/influxdata/flux/commit/68c831c40b396f0274f6a9f97d77707c39970b02
    resource "flux" do
      url "https://github.com/influxdata/flux/archive/refs/tags/v0.194.5.tar.gz"
      sha256 "85229c86d307fdecccc7d940902fb83bfbd7cff7a308ace831e2487d36a6a8ca"

      # patch to fix build with rust 1.83, upstream pr ref, https://github.com/influxdata/flux/pull/5516
      patch do
        url "https://github.com/influxdata/flux/commit/08b6cb784759242fd1455f1d28e653194745c0c6.patch?full_index=1"
        sha256 "3c40b88897c1bd34c70f277e13320148cbee44b8ac7b8029be6bf4f541965302"
      end
    end

    # build patch to upgrade flux so that it can be built with rust 1.72.0+
    # upstream PR ref, https://github.com/influxdata/kapacitor/pull/2811
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e1d275be21f72a5d07dfe920c4ce7692f818761e/kapacitor/1.7.6-rust-1.72.patch"
      sha256 "4e82470590dcaaac7e56c52f659e31107116e426456b74789daf9364039907f0"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8247430a0e749413545540c04d418b0adeed5d37d83319e69751596322a1c9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d56568c7ae7bca2be7324da1c5bdc4fc7f086ff1054a786f0fed2670225ca710"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5b98fcf4136a43925d791c4c803dbaabd62e5167dca2863343551b6e4a3ac70"
    sha256 cellar: :any_skip_relocation, sonoma:        "33549402f35a9bb69c36a731c6b24ecf9ac57cec0ecb790a3f8a301b4ced507e"
    sha256 cellar: :any_skip_relocation, ventura:       "de2e14999f1f6714d3504c183bd35f8b37fed4a4d886b266cf175040fcd37bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e963db4b37cde0cba4449f211213422a9ebba18f121a77e2cacfc90e6eb2fc5"
  end

  # Go 1.23 results in panic: failed to parse CA certificate.
  # TODO: Switch to `go` when `kapacitor` updates gosnowflake
  depends_on "go@1.22" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build # for `pkg-config-wrapper`
  end

  # NOTE: The version here is specified in the go.mod of kapacitor.
  # If you're upgrading to a newer kapacitor version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.12.tar.gz"
    sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"
  end

  def install
    if build.stable?
      # Check if newer `go` can be used
      go_mod = (buildpath/"go.mod").read
      gosnowflake_version = go_mod[%r{/influxdata/gosnowflake v(\d+(?:\.\d+)+)}, 1]
      odie "Check if `go` can be used!" if gosnowflake_version.blank? || Version.new(gosnowflake_version) > "1.6.9"

      # Workaround to skip dead_code lint. RUSTFLAGS workarounds didn't work.
      flux_module = "github.com/influxdata/flux"
      flux_version = go_mod[/#{flux_module} v(\d+(?:\.\d+)+)/, 1]
      odie "Check if `flux` resource can be removed!" if flux_version.blank? || Version.new(flux_version) >= "0.195"
      (buildpath/"vendored_flux").install resource("flux")
      inreplace "vendored_flux/libflux/flux-core/src/lib.rs", "#![allow(\n", "\\0    dead_code,\n"
      (buildpath/"go.work").write <<~EOS
        go 1.22
        use .
        replace #{flux_module} => ./vendored_flux
      EOS
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
