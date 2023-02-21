class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3236.tar.gz"
  sha256 "d5121a32e9176181862d3ad221766ab7eedeb75163b6f1ed01cffde968a1bfee"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0839ce0afb1a7bb3a98e13a05da5eee716aac465c7aa47f2a0add5a582e3a0e7"
    sha256 cellar: :any,                 arm64_monterey: "33437b8f65b1d611751a39ee8f4d3937082c84af36ba4cb7c33103360ae5be4c"
    sha256 cellar: :any,                 arm64_big_sur:  "c29822ea6ea314abc5610f4dbb43fa6ac967d45b3ab4f853da93e38be6ff3531"
    sha256 cellar: :any,                 ventura:        "71764db7fb1aba8439a04e5b511f954fc839a15ae2cce19db3e06194961cc797"
    sha256 cellar: :any,                 monterey:       "5be35ccfaf8f8e4bfe461071b52f4f58b484c7b7415abd74ba20b4fb155eb3d9"
    sha256 cellar: :any,                 big_sur:        "dd53c1368189beb0f50a07d6bf3d0f0fc6ea04a472e96ce198bc7a66f5f2db9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee6c8655d57a71ce18cbe717091bdb975e22c0b0cfb9dde16b02c30f131b2a8b"
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
