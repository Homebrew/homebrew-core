class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3288.tar.gz"
  sha256 "64a6af40e73049edd3341d6eeb2124c80858e17b817c8a59de1a1cdbb6477f9e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bfb26a4a87b2646740349c1d15acefe9c043188bbec6f38c71cf3afb7a2e6df3"
    sha256 cellar: :any,                 arm64_monterey: "1a9a24f40f28865a09bdc2bcde0af602579091798dc49a49fc16691a99d1c8f3"
    sha256 cellar: :any,                 arm64_big_sur:  "9ddd7a401eab1eeae21df98db14d72778bd826b00a2b3b6c7fe526624d2c0eab"
    sha256 cellar: :any,                 ventura:        "054da6f732ff78d8d3487a3a1db7e4bcc517eba82a75b9eda7c460a47e9d9f0a"
    sha256 cellar: :any,                 monterey:       "834fac783c1f3b369eaa7ff4d95e1e14a22016170a3c2e10b844067647f5cdc9"
    sha256 cellar: :any,                 big_sur:        "5450f52d430e86d00dd5a7c6477b3f4950062ec1804b618f33c294b56744ef99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53bc5eb3a8397d0b7b9c84a2c8f04a5a538a478942e3f00c2ef373a08bbdb6e5"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
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
    working_dir libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
