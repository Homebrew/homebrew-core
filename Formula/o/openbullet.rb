class Openbullet < Formula
  desc "Automation suite for scraping and parsing data"
  homepage "https://github.com/openbullet/OpenBullet2"
  url "https://github.com/openbullet/OpenBullet2/archive/refs/tags/0.3.2.tar.gz"
  sha256 "4e8c5e6aa9e70796666061ed73c6a4a0e5f012a0d8c5675c78d732db61b826f7"
  license "MIT"
  head "https://github.com/openbullet/OpenBullet2.git", branch: "master"

  depends_on "node" => :build
  depends_on "dotnet@8"

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    dotnet = Formula["dotnet@8"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{buildpath}/build
      --use-current-runtime
      -p:Version=#{version}
    ]

    system "dotnet", "restore", "OpenBullet2.sln"
    system "dotnet", "publish", "OpenBullet2.Web", *args

    cd "openbullet2-web-client" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build", "--", "--output-path=#{buildpath}/build/wwwroot"
    end

    libexec.install Dir["#{buildpath}/build/*"]

    rm_r libexec/"selenium-manager" if (libexec/"selenium-manager").exist?

    cp "OpenBullet2.Web/dbip-country-lite.mmdb", libexec if File.exist?("OpenBullet2.Web/dbip-country-lite.mmdb")

    (bin/"openbullet").write <<~BASH
      #!/bin/bash
      export DOTNET_ROOT="#{Formula["dotnet@8"].opt_libexec}"
      export PATH="$DOTNET_ROOT:$PATH"
      exec "#{Formula["dotnet@8"].opt_bin}/dotnet" "#{libexec}/OpenBullet2.Web.dll" "$@"
    BASH

    (var/"openbullet/UserData").mkpath
    ln_sf var/"openbullet/UserData", libexec/"UserData"
  end

  service do
    run [opt_bin/"openbullet", "--urls=http://localhost:5000"]
    working_dir var/"openbullet"
    keep_alive true
    log_path var/"log/openbullet.log"
    error_log_path var/"log/openbullet.log"
  end

  test do
    port = free_port

    (testpath/"UserData").mkpath
    ln_sf testpath/"UserData", libexec/"UserData"

    pid = fork do
      ENV["ASPNETCORE_URLS"] = "http://localhost:#{port}"
      ENV["ASPNETCORE_ENVIRONMENT"] = "Production"
      exec Formula["dotnet@8"].opt_bin/"dotnet", "#{libexec}/OpenBullet2.Web.dll"
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
