class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2404.tar.gz"
  sha256 "5f15b9b214f003e37edc68993e872e2465e347c33c7cfd232a24dfeff12743da"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dfcea759009b980c01013caff4fb8bbdc8c675fddb302a535f36204f6e9e43e7"
    sha256 cellar: :any,                 arm64_sonoma:  "455427fde5d42524bc6cf7ca65dd15a4d2016cf220e85d7bc800d6daeb5ad09b"
    sha256 cellar: :any,                 arm64_ventura: "dfb8426316209999744454cab4ad87c7c8d926b3df9656785e1dc11e79ef5bb5"
    sha256 cellar: :any,                 ventura:       "d130ffa1e3f136b88633250889acfb9a7c9ced96afccd317b667eabcc15f9bbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5d8ffc9473040330c1c467d4e9b34ea540667ef7c57e8bd05261d892f0d6046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b88ea6f5a6d58d697aba161c7f2b61c0ef6cbb256068ea8192ec618759db428"
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
