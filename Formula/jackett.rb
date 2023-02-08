class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3004.tar.gz"
  sha256 "a497747fb5963aa675ccfc2e0257da1acb28504a0f716bb368cee88216dc497f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d4ce99b69178e59c0999e53755e92c3532dce4b9d3bcb40990868ea3368c5c0d"
    sha256 cellar: :any,                 arm64_monterey: "a812319f152c436c2d41116ceab75ebb6a0579a59c23574c1b2c6c4bf277a72c"
    sha256 cellar: :any,                 arm64_big_sur:  "3bddef3d3470bd89656b8e67c1af47c1d5959a3d576bb81ada9fb21a259fec50"
    sha256 cellar: :any,                 ventura:        "35ac0d912a04dbc5333be6c7f83ed2827c2c20aac8513c943ff9c02b2a1c1b01"
    sha256 cellar: :any,                 monterey:       "4c98d70ebd453ab9cf33be383479e462622d5c610f3cf4c8843821d77fe8aff0"
    sha256 cellar: :any,                 big_sur:        "9f51b7bdfaa0742ad86fe213a8d42e456208c90b9d55923782cd44ea2134489c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "456868753de8e74648df2db4b23d467ad36408070bfc06a06bb7a92abcff0209"
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
