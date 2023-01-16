class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2660.tar.gz"
  sha256 "ef968b0ca34fdbda409c008b06eab0e306b1af8738f8ba546811ad9d367e61da"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2995543e93e3d8d56c5662eb7c475c4dd7c5a2ac5d14f29b74e869b4bf3155b7"
    sha256 cellar: :any,                 arm64_monterey: "3c7b33b0d1f6f70f37d526ac9a9f465c17e5fac96524cb41dce3f800764b3772"
    sha256 cellar: :any,                 arm64_big_sur:  "36c8e95e043adb4bb9e229901228dd210dae1117e651057c254ab3b06cab2d15"
    sha256 cellar: :any,                 ventura:        "befbb69e022b9a826a25476821f14c063a59e4140c0b61db426585db10cf4810"
    sha256 cellar: :any,                 monterey:       "678f98c06328e9055d540652275e9db6fdd28ef8670c5e440213dfa6d72eac80"
    sha256 cellar: :any,                 big_sur:        "50dc9fda668cd60c4eee57cba2e2213d783e92250cf4ef51b74a439520df879d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95aad595957136d33119cf6bd4b929cdac1310e780dd4b0772454e141ca67c5f"
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
