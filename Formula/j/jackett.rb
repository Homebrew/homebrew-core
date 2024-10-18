class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.812.tar.gz"
  sha256 "3c31d8bbab02c18248593da966e19bdc8767abff86c307a8595e771edfab9bdd"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "861fb5d54b7e896a123ea43eeee4b12d53f934c6b5ad458bbd5a83ec299fca10"
    sha256 cellar: :any,                 arm64_sonoma:  "fad35b983ee09b3872aa15f8ec8bc8762e2402d13c4ce1480a50b73e76fdb7fd"
    sha256 cellar: :any,                 arm64_ventura: "77f62067c64799343e08c1a0281bb0648e6007b1356f784d2d4ee829fbfc2808"
    sha256 cellar: :any,                 sonoma:        "f3ab0f054e9e31defe53bcd20a28457c776f9e35b1450329893a39d5d861fdc4"
    sha256 cellar: :any,                 ventura:       "966b73a66d4ddac0a22969ec4cf4e417cf457a628435447eacf2f9c5d12ee3eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72260038a7a52c4eb5a701530dc56401ae35c8db0645381cfbd1fba2b0743ee0"
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
