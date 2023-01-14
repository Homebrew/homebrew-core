class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2629.tar.gz"
  sha256 "0822dbeab344aa2487d1a84405627e8ae9a0982a77a80dbc30cbe117a7f47081"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7580ab53395690756198a1d0b1195c18ddaa37e2cf74ebaa16c3b951cf3b511c"
    sha256 cellar: :any,                 arm64_monterey: "8e4dd90ac4981637b03898e904a2c60a60b7774a453aa19bf46ea8e166d537c4"
    sha256 cellar: :any,                 arm64_big_sur:  "ed1e0b468188dce28f950ffc874e835f07287613139857ac309bebac778c00f8"
    sha256 cellar: :any,                 ventura:        "e2df9cca314d99f21fd262d60f0d7428ca66c34221088f8a0c5db0013ebdad70"
    sha256 cellar: :any,                 monterey:       "fc60ea168ec1a0f79551de93f26ed9851a9202ffdc76be981d1ad29c9dc46523"
    sha256 cellar: :any,                 big_sur:        "9c34c640b499108b3eb5cd4d585ae85ef02a5be0b1f483f2cb86505ee3fdf472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19fae81d3547211cf605e52e7bf64b7da09e3b01d9747fd0b0371a09d0e7623d"
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
