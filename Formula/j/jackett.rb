class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.820.tar.gz"
  sha256 "77052c0fd9d81c08853c97c631fa574d6ac21eda9a7e345f68b00deff15ee8f8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "80632f227055b5492bb758c47df5c9b8d1967a46ad0111543b1b97d690215561"
    sha256 cellar: :any,                 arm64_sonoma:  "7315e794ffcbbefacc418c78d8e69a31db6554dfe8e82dffe546dee41c14fab7"
    sha256 cellar: :any,                 arm64_ventura: "3203ae6aafc1f389c33a5e4bf3e8b99dd6bfc84ddc272d761e622898b8f85b11"
    sha256 cellar: :any,                 sonoma:        "9777e8b09ce8eb47542613c97aaf880154af651137ccff99ae350c21a0117abf"
    sha256 cellar: :any,                 ventura:       "a49f17c8b2784215067ac273ff75e5ddc87709235a1fbf51e62e47a2ea8d3ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec11bb3a1fd0bbb2e9f24d6f8dbeea2b379a50028cf428f120b2db28951426b1"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
