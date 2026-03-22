class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1427.tar.gz"
  sha256 "8e6526b3a7610bba0931475cc1153082319f89a49f6a3590f529ed2c325b7255"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3debf79e0b9244ca109fa5aca630261326826e3e45ebbec68aac83657e134fce"
    sha256 cellar: :any,                 arm64_sequoia: "92e989a8120ce22df7d07bfd5156244fdbb365e341dc79757e7c729a4528c4d9"
    sha256 cellar: :any,                 arm64_sonoma:  "38cebb5f7f2b7d125e2a6eb40a6d05053c993586511e4d8ce9ee689c61bd8fe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f18d3f7f441694d6ee72a215e4939f2366bd69599e22ca13b1144ba96fe224c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "209257e879d351d710219aa2d72194ac86bb0bcf1c7b32cf36ed73fbf4040096"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
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

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
