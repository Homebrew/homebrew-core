class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2103.tar.gz"
  sha256 "17e275956eb67d574bca011fb00056f5934934afeaf09cf2b2cd1a935f251673"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e5a8906a4f224ce63129781e6c753824f5e8a3083451739e9d8477c4729fd119"
    sha256 cellar: :any,                 arm64_monterey: "54278d504a56a8351157345ba1581034fa4c86e4ce1f9accd6d98b923c9f17ee"
    sha256 cellar: :any,                 ventura:        "ce8649b2f1dfcb88989df7bd575de7bf91efacb257d07bb4f3a4966778226880"
    sha256 cellar: :any,                 monterey:       "675b9a5559ddd21692b5767baa3dc959aa4911243ee60ad61aa528c83b7d53e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "025ce9a86b262841bea1f49c40b4b688fa7178c05db13be601a1c39b26a0ec32"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
