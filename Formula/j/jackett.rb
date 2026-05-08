class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1822.tar.gz"
  sha256 "876fc1547a0bca8490c6a190acb8f67601918f4cedbb5cd5ce48f1f04fe3359d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30afea8a94edbe630fa0c1dd4f7fe923cda009a5e2fa0d65f515f5eb901a6c63"
    sha256 cellar: :any,                 arm64_sequoia: "e1b0e53848f9b05ab359ea5e2afb30e2a7b404d37cca8ca2fc52157f3c06382e"
    sha256 cellar: :any,                 arm64_sonoma:  "f590af007c71cc48bcf25345cefacb6664fd5e0849484c4e9047eb0cf916e1bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a7c3ae951bfce04b00d574a73c589a38d5ff93fa2e895e441bb279d6738934c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e96fdc024672cbee3e78c64538827748fdb7d7f57ec2c7381c6b161c249c5245"
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
