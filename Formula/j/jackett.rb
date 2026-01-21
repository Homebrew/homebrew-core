class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.898.tar.gz"
  sha256 "f48a6ac011d731072163aa04b7c6b9f7aafdd3c937bf239ae193387ba8398932"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "46626c153842791b1a3bfb22c1571431c48c2479475417098b824ed2dad1783b"
    sha256 cellar: :any,                 arm64_sequoia: "760ebc66a83678b46656d2579c28aeca68311e08ff675286c99df0445ceb1e96"
    sha256 cellar: :any,                 arm64_sonoma:  "495e7e194337d43ca46502aa692612863dac65a84c68043b24e4a345db839593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f192c894838ee0abceb292b7a603526e104c052ee97ad32c8710a3a7b663051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70ae0c8594d29b8dc4d2d8c3b68e400c479acda9a1cf52ccead3ff78945e8053"
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
