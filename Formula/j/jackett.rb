class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.1372.tar.gz"
  sha256 "738ac36d57f72abd81438b11d6264dcae3a220902a3d63fd00e4bf3362eb0b6b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c426f5107effa445b64cb9e13fa3f60fe66ede65427f105c1a22eb90a364e17c"
    sha256 cellar: :any,                 arm64_sonoma:  "5d5b3d71d364cf5f615f9d39ee4ecb06f1f06f2fd4d1e6110bd33a212e788232"
    sha256 cellar: :any,                 arm64_ventura: "adf5e9f5ffb1cd7c30d4cac3c2dab8c010895af99bc4871ced9df1ab2acf5fb1"
    sha256 cellar: :any,                 ventura:       "c340986a4834ec6f9132746286fce34622964e6736324e6ca4c0930fce1ae015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94676312e550b2e588b4712f6d4b97732fae09577847cf2a1d0c17ed432bcdc"
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
