class Openbullet < Formula
  desc "Cross-platform web automation suite"
  homepage "https://github.com/openbullet/OpenBullet2"
  url "https://github.com/openbullet/OpenBullet2/archive/refs/tags/2.0.1.tar.gz"
  sha256 "13aada62e6e14200b6b119424222cb8f134b1ec7f9139bb4630daf9c8584275c"
  license "MIT"
  head "https://github.com/openbullet/OpenBullet2.git", branch: "master"

  depends_on "node" => :build
  depends_on "dotnet"

  allow_network_access! :build

  def dotnet = deps.find { |d| d.name == "dotnet" }.to_formula

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath

    cd "openbullet2-web-client" do
      system "npm", "ci", *std_npm_args(prefix: false)
    end
    system "dotnet", "restore", "OpenBullet2.Web"
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["XDG_RUNTIME_DIR"] = buildpath

    cd "openbullet2-web-client" do
      system "npm", "run", "build"
    end
    (buildpath/"OpenBullet2.Web/wwwroot").install Dir["openbullet2-web-client/dist/*"]

    args = %W[
      --configuration Release
      --framework net10.0
      --no-restore
      --no-self-contained
      --output #{libexec}
      -p:DisableBeauty=True
      -p:Version=#{version}
    ]
    system "dotnet", "publish", "OpenBullet2.Web", *args
    libexec.install "OpenBullet2.Web/user-agents.json"

    runtime = if OS.mac?
      Hardware::CPU.arm? ? "osx-arm64" : "osx-x64"
    else
      Hardware::CPU.arm? ? "linux-arm64" : "linux-x64"
    end
    (libexec/"runtimes").children.each do |path|
      rm_r path if path.basename.to_s != runtime
    end

    (bin/"openbullet").write <<~SH
      #!/bin/bash
      export DOTNET_ROOT="${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
      export DOTNET_ROLL_FORWARD="Major"
      data_dir="#{var}/lib/openbullet"
      export Settings__UserDataFolder="${Settings__UserDataFolder:-$data_dir}"
      export ConnectionStrings__DefaultConnection="${ConnectionStrings__DefaultConnection:-Data Source=$Settings__UserDataFolder/OpenBullet.db;}"
      mkdir -p "$Settings__UserDataFolder/Logs"
      if [ ! -e "$Settings__UserDataFolder/user-agents.json" ]; then
        ln -s "#{libexec}/user-agents.json" "$Settings__UserDataFolder/user-agents.json"
      fi
      export Serilog__WriteTo__1__Args__path="$Settings__UserDataFolder/Logs/log-.txt"
      cd "#{libexec}"
      exec "#{libexec}/OpenBullet2.Web" --contentRoot "#{libexec}" "$@"
    SH
    chmod 0755, bin/"openbullet"
    (var/"lib/openbullet").mkpath
  end

  service do
    run [opt_bin/"openbullet", "--urls=http://127.0.0.1:5000"]
    keep_alive true
    working_dir var/"lib/openbullet"
    log_path var/"log/openbullet.log"
    error_log_path var/"log/openbullet.log"
  end

  test do
    assert_path_exists bin/"openbullet"
    assert_path_exists libexec/"user-agents.json"
    assert_path_exists libexec/"wwwroot/index.html"

    data_dir = testpath/"data"
    env = {
      "Settings__UserDataFolder"             => data_dir.to_s,
      "ConnectionStrings__DefaultConnection" => "Data Source=#{data_dir}/custom.db;",
    }
    pid = spawn env, bin/"openbullet"
    begin
      30.times do
        break if (data_dir/"custom.db").exist?

        sleep 1
      end
      assert_path_exists data_dir/"custom.db"
    ensure
      if Process.waitpid(pid, Process::WNOHANG).nil?
        Process.kill("TERM", pid)
        Process.wait(pid)
      end
    end
  end
end
