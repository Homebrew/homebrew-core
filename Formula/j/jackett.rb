class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.31.tar.gz"
  sha256 "14442fad2fb0e2a9970375def4995cfb982bfc9bb0b481e6ee4db46de5527ebc"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f2abf0e341225356ca8e034c293c5604f504b3b44d6e708a137f8d0d524d3e2"
    sha256 cellar: :any,                 arm64_sequoia: "3f7383047a8650db50c4bd48d57662d2267bf6c96c880665a5e61c1270e21a59"
    sha256 cellar: :any,                 arm64_sonoma:  "e59efeece22194332f8d0fc8286b81c8111456d5b2e370a156ff528c9622a254"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1060a939ee58edc455892fbd74024af0e15de8cbdafaf1b1549860d0c21d4b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b9038546e75c1bfa5d30adf02201de69606d0088cf8c84f91726af5bb3f489"
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
