class Openbullet < Formula
  desc "Automation suite for scraping and parsing data"
  homepage "https://github.com/openbullet/OpenBullet2"
  url "https://github.com/openbullet/OpenBullet2/archive/refs/tags/0.3.2.tar.gz"
  sha256 "4e8c5e6aa9e70796666061ed73c6a4a0e5f012a0d8c5675c78d732db61b826f7"
  license "MIT"

  depends_on "node" => :build
  depends_on "dotnet@8"

  def install
    ENV["NODE_OPTIONS"] = "--max-old-space-size=2048"
    cd "openbullet2-web-client" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
      (buildpath/"wwwroot").install Dir["dist/*"]
    end

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_NOLOGO"] = "1"

    system "dotnet", "publish", "OpenBullet2.Web",
           "--configuration", "Release",
           "--use-current-runtime",
           "--output", libexec,
           "--no-self-contained",
           "-p:DisableBeauty=True"

    (libexec/"wwwroot").install Dir["#{buildpath}/wwwroot/*"]

    if OS.linux?
      rm_r(libexec/"selenium-manager/linux") if Hardware::CPU.arm?
      rm_r(libexec/"selenium-manager/macos")
      rm_r(libexec/"selenium-manager/windows")
    end
    if OS.mac?
      rm_r(libexec/"selenium-manager/linux")
      rm_r(libexec/"selenium-manager/windows")

      deuniversalize_machos(libexec/"selenium-manager/macos/selenium-manager")
    end

    libexec.install "OpenBullet2.Web/dbip-country-lite.mmdb" if File.exist?("OpenBullet2.Web/dbip-country-lite.mmdb")
    libexec.install "OpenBullet2.Web/user-agents.json" if File.exist?("OpenBullet2.Web/user-agents.json")

    (bin/"openbullet").unlink if (bin/"openbullet").exist?
    (bin/"openbullet").write <<~EOS
      #!/bin/bash
      export Settings__UserDataFolder="${Settings__UserDataFolder:-#{var}/openbullet}"
      export ConnectionStrings__DefaultConnection="${ConnectionStrings__DefaultConnection:-Data Source=${Settings__UserDataFolder}/OpenBullet.db;}"
      export DOTNET_ROOT="#{Formula["dotnet@8"].opt_libexec}"
      cd "#{libexec}"
      exec "#{Formula["dotnet@8"].opt_bin}/dotnet" OpenBullet2.Web.dll "$@"
    EOS

    (var/"openbullet").mkpath
  end

  service do
    run [opt_bin/"openbullet", "--urls=http://localhost:5000"]
    keep_alive true
    log_path var/"log/openbullet.log"
    error_log_path var/"log/openbullet.log"
  end

  test do
    port = free_port
    user_data = testpath/"UserData"
    user_data.mkpath

    pid = fork do
      ENV["Settings__UserDataFolder"] = user_data.to_s
      ENV["ConnectionStrings__DefaultConnection"] = "Data Source=#{user_data}/OpenBullet.db;"
      ENV["ASPNETCORE_URLS"] = "http://localhost:#{port}"
      ENV["ASPNETCORE_ENVIRONMENT"] = "Production"
      exec bin/"openbullet"
    end

    sleep 30

    begin
      output = shell_output("curl -s http://localhost:#{port}")
      assert_match(/OpenBullet|openbullet/i, output)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
