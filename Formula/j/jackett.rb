class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2016.tar.gz"
  sha256 "59dcd0319384f19e1b4060278a50b4fa9b1c995eacd1a4615a2aacdc6c83502a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6a4cc7d7fa20a7ce22b54be94511ac178ecff9f15dd44e2e89d5501cfd6bc78"
    sha256 cellar: :any,                 arm64_sonoma:  "8623217d1e14ca2c51897a732657a53decd9212f3283c681c55b4e925804a3a3"
    sha256 cellar: :any,                 arm64_ventura: "03156d04aa7b29b5161af1f55ede542119714b0011ebd96f224e6ba7ba35553e"
    sha256 cellar: :any,                 ventura:       "ec944ce4488ac25bd29b96368f98237f6a7e5032cf9b237d31d23aaa0db81712"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30d25a0fc025d5f96e27865fab6e32d0e12bcf746978e0f7e80967994847842c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7900068ce9f8b4da3ab9052bcc39748491e884af3147edd72853f80971ec711d"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

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
