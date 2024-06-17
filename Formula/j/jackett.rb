class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.136.tar.gz"
  sha256 "b2c04292f254f44233ad433f7babe4d207c27310fbf1c9019a895088fea33210"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2245cde3a1a4ab9fc525dcfbc26b38395be426323cf17f39f453867af9cc114f"
    sha256 cellar: :any,                 arm64_ventura:  "e6c27e96fdaadb7412e9f55390398143fd9af46f9069938199ef4444a71ab5b2"
    sha256 cellar: :any,                 arm64_monterey: "765a21f977b7144f6b6e1bc54ed79a526f0962dc11e7e84cde3ca8e525078d05"
    sha256 cellar: :any,                 sonoma:         "4192dcd70811014b5d08a04a591e4ee1732cd8be685f2078c99b2a938b596d80"
    sha256 cellar: :any,                 ventura:        "30b39c9a79f9d18477bbdfe5e099ec151415231966ebb6d9f9fee207afe9f52c"
    sha256 cellar: :any,                 monterey:       "02fd2c4db15f88c2f2a7cf9823b169099db552e7653cb6a3f7a3941c6e14a98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4421d544623a7df8ba714bebca2de2321af1b0ff22123a027863e6c62c8e108"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
