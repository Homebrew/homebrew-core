class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1792.tar.gz"
  sha256 "f229ef74ff89dc345532967bef6422e96cb6f9f083ddb42d1a3fe2fd48db3686"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "025aa3dbc126b3eec61e3c71d197ab54bfc2089a8c658792f52ed97501e19f1e"
    sha256 cellar: :any,                 arm64_monterey: "b7d3a919c3cfb971ab88948ab91361178ec2412fb959c083724ab43612ad7f6d"
    sha256 cellar: :any,                 ventura:        "932f2ec3cf60cced7f5cce376344ecab58dde14d77b87acc01a4860e0c7f0f48"
    sha256 cellar: :any,                 monterey:       "36e0201b750761e29b05f9ee54fc2dd72a5af134952d3834268838e3cb5aa430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e720d1d746ed1522d4194e6b2cb94b78036ba364dd095f9fdf2b17b122f06c5"
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
