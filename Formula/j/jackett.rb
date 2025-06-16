class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2020.tar.gz"
  sha256 "1fc7c7d1d1fc83354f535196e3a829eb3d3d5c53ab94047525361c254d81e86c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4d8d55b1d342afa015504c2575b0ba1e9ea276e2b669b6e8917d0d5cdd22ea5f"
    sha256 cellar: :any,                 arm64_sonoma:  "9ef306d561f8d9b66b2f738835d5c58e0110eba41991bbd6017ca30ef06de52f"
    sha256 cellar: :any,                 arm64_ventura: "6e4c41f7a51e771199ea9142730169a98d1a3e6d35950f9c69bc58d7d73817aa"
    sha256 cellar: :any,                 ventura:       "7076013ee883b4b91b08e4168c997833231a9f28bea87b5bce3158556871e21f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17b4724e7525c6156fa92a216f246bba8bef417be7dd3a8743a02011fc30ffd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fed06a7d8c9672dd7659c2700e48ad431e2696e55d6f6147e69780a42a6a3a64"
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
