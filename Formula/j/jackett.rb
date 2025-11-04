class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.247.tar.gz"
  sha256 "901b25c134bc0a52a63c73d9dbc6d6b76756a34aeb4037eb97342900a761e6ff"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e0af6e46bc396efe0ba8148554a22a0a7d5e1cf0995a519173631fb58249857"
    sha256 cellar: :any,                 arm64_sequoia: "892beb8f32eac8b916648d4d2f9a392655dfc091c9cbb517051c32167ace15cf"
    sha256 cellar: :any,                 arm64_sonoma:  "efd82e74b88da929630c2d7af5b1c588549898fd87ad52b8afeafd5bf777c248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b899a39f5ac214e7223fbeb9093aeec7c3df24de89b34ec2fb9c1f2073b76ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd7d33a70336bfb70b24fc48d646899637d4146a3f8530e193611c2ac5cc84a0"
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
