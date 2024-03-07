class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1960.tar.gz"
  sha256 "edb3ef34a1fdc0aea48d9db6ea0d5b53fff82d9561c49248b761c57e3ca3b581"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "23df5cafcea09497ad2999eb057c68c8b5e4c34ae791aa932b73854c5855b235"
    sha256 cellar: :any,                 arm64_monterey: "3c0fe9082aeec96faf06be438da594575351e0a5ed1e1dbc19c2c03f0f0969b8"
    sha256 cellar: :any,                 ventura:        "87588691e2d39a8cc6bc843d0f6d30d2e5f8d1081f4bde2019c28aaec9b059c9"
    sha256 cellar: :any,                 monterey:       "0fd12c4919b8f15c4ee9a91a4709a819b2bfb86eb52397c8071a65495974c5ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "279895a21b78c5e0eb55d849b43dcbf52fe2be6f3bd4bef4eaaf93424627d5ac"
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
