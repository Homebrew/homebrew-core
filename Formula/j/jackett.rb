class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1855.tar.gz"
  sha256 "c300bbd70def8fa73cda27b06f9fe5f4649ea1d6f8847debea384c7d1e9d561a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5a78091bfc78ea1bb934f0f88860f8ba244c8810d44878e0703a2c5e010356f"
    sha256 cellar: :any,                 arm64_monterey: "3d8ece56c4d717cf5f769316e668cf3ed7375378b2270d1c16d324a6cdcb1146"
    sha256 cellar: :any,                 ventura:        "92185b2692432a42dcd50fc16c4a86f841c681bca7fc0b429ff91923d2b330bc"
    sha256 cellar: :any,                 monterey:       "51d7841211d5c9fa9dbc18fb542c90784d9a8cb390070c257b0196b719f9ce9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dce1acc47af8ade940d08d930a8a26044f65eb778af342438dea7e1303d7dcdf"
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
