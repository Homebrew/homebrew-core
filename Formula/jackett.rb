class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.584.tar.gz"
  sha256 "c8be841886cbdfd83498ecc155ff584cbed79d74adfb759a4c073a4d8ef3f00d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "378dd475d2fbfb4c2c36ff1e1f88b8051f7f61dafccd8a0c5b024fc96d6f9d9c"
    sha256 cellar: :any,                 arm64_monterey: "0afc38669c6044b400396524caec38fc84ba3272b43729ce67327ee5a4b17cee"
    sha256 cellar: :any,                 arm64_big_sur:  "8a11dc67284c607f10a9222eb251c4e9ca5b190814d0de408f394162cdf35b5e"
    sha256 cellar: :any,                 ventura:        "a223f79edf234e4bda644c1a2b63952d6e204811a40953a099d30d4a7e87f3b3"
    sha256 cellar: :any,                 monterey:       "03600248edd22ef8796a3a770b998a4862fc61033ce8672ddd808918032f1e5e"
    sha256 cellar: :any,                 big_sur:        "fad7fcc504d277c8d7713dc4190ddc6e2914b24cd0ed4767aad5d188ad8ae517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38c327c3cd81f04ffaf35cc0b3c940b3719ec727b8d9bc68eb476672ff674fd0"
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
    working_dir opt_libexec
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
