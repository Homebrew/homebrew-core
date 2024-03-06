class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1956.tar.gz"
  sha256 "42b1baea3d7c9563293e2ca15f5b4e24c3c998429aefc94f55d94d24654ebf95"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "601d860c8da8de0f5f8eaf760bf7b97262e6f304a4cda932a8af0e3d6e5e4160"
    sha256 cellar: :any,                 arm64_monterey: "0a7a719d4723d8bed472035eeab5f581839a2b833edd1017023e82bea364ef15"
    sha256 cellar: :any,                 ventura:        "f02e44b447a97d108bdf0c6d3e6af0024b375287c45a5d667f9abd871ea5db77"
    sha256 cellar: :any,                 monterey:       "9dd0e61f39ad52518f157425608b4aadb7da5745b4594018ab2ac1cfa36aee9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1c85da42af21f1dd67ecd209ac7386e7108426487ca4912183d6795fb5417c6"
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
