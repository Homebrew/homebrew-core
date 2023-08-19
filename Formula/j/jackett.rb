class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.662.tar.gz"
  sha256 "5c2ea092a8d084a1d68f8e3b12838696a61ec6df032bc7db0ad658c560322c4e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cc69932fbc31af5cf5606ea2fcb02cd9bc84b5fd7e20535c3ae9c424039999ce"
    sha256 cellar: :any,                 arm64_monterey: "85676be7031126c8e6f1c1a57edcb5173285ef39c71f40d2f6124c3a8ed43763"
    sha256 cellar: :any,                 arm64_big_sur:  "8ac65cd60c27393d841f584ff015953fe1b0f64c500542e3938f72b28f8d6326"
    sha256 cellar: :any,                 ventura:        "663fd8ff75213ffc6717d0ec8cf61e63547480a1dc5c79a0b101d1dec7b23b93"
    sha256 cellar: :any,                 monterey:       "180569ecc1e429083ce28f7ed052466df5581e6f1150c74fa890ec2c463c4ef4"
    sha256 cellar: :any,                 big_sur:        "43333289f905f7c80c5389686ed7f09c51c620e563959cd4097cc08ea4452c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "300cbba53677606f3179817f7f0e8aabf5a3bafda09140dc7a1c890a15998779"
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
