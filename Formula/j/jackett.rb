class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2434.tar.gz"
  sha256 "93a287a7a837c198c9b323a61d2dcd66642552b6dd5e36fd446ec958553341b5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ba80577ae92027f095b97d511295f2c56ec9fcf99efa4add95b4899b5661a679"
    sha256 cellar: :any, arm64_sequoia: "029c3dee84146059139f9ead623a2a5af42b85dda7cbca159cc4bd67012571ea"
    sha256 cellar: :any, arm64_sonoma:  "aafa147b31e4b99c8dfd270781f30b1e1722217e85ca3e08daaa90a3b036fb52"
    sha256 cellar: :any, sonoma:        "1bf7f1ab6b1bf7b9bf1341b9751337da73cb2396f1e1933133360511b4d56ea7"
    sha256 cellar: :any, arm64_linux:   "fd52393743ae375513e4e2a2af6bf4616c3ffe3d340bcf66f7e1f6266e773bf9"
    sha256 cellar: :any, x86_64_linux:  "8da15fb2f4abdb1409c34bdd78b238e47b399ec4a191261bf50676c6dfd1b022"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

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
