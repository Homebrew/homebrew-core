class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.340.tar.gz"
  sha256 "212a9128cace0ff044e9b3d256181372166f7fb28e11a4a07456d68794e771b4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94bd925dfdb17748833311972f81bace2e7ffc4506be0980a6585b09f84f982e"
    sha256 cellar: :any,                 arm64_sequoia: "d6e2802ff33e7aa154ba586c965f4bfa00f7b56f3c0d0485715751577b205e9e"
    sha256 cellar: :any,                 arm64_sonoma:  "d93a0226def64808f620d6d4250e741792b2dc61655efa2bdb96fdbebf6262a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7746a833c3c0f75ce44ab8a82f403d2d4120a9a069818faae9812177b52ca58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "272d9e06b1ae35d24fc546e5d837d6d24a457af0102e9fec6516fc310b989b0b"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

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
