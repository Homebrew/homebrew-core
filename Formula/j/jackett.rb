class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2154.tar.gz"
  sha256 "83dfd18912b8c9084571e6cf873331f405b0f288e6a9ce6440e0043037c6a86d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b42c7e6aa0133ab39c5c8a8ac495e31576bb077a0f3447b5096b637c5cd03562"
    sha256 cellar: :any,                 arm64_sonoma:  "bc25a1ce5cb42333c571c5f54c1c41030a77ccb2b887f2b5a0e3c5eca57d2805"
    sha256 cellar: :any,                 arm64_ventura: "0bf22daca61dd7480244c417f44c59196cf5556b2dc2ba1a098e5720f90a2c2e"
    sha256 cellar: :any,                 ventura:       "84f2f7046d7a9580b7075abe32b5cb8a48096b7f13b770c0ab1cfb9cb76cf4ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f2412d75d955439cd07e83be3003dc0e0cce482833e7c3d0efcecdc874dc108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97a9823ac305811a484b5afcc92b86d9864c50e423551fbbc16b986ca5d6117d"
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
