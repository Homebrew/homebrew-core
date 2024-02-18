class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1776.tar.gz"
  sha256 "4f3c626832bbbcbfd0645562f58e508023d7723f0a53e105350b3a747e29b839"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1fa731d54a0fcd2be4a1262364ce843e4fb613271182f04d9605d3df4cf94316"
    sha256 cellar: :any,                 arm64_monterey: "ac272515e4086de1d26f3333e215fd504e10faddbb7b075f3903ee489ff41eeb"
    sha256 cellar: :any,                 ventura:        "0a1e3082078496d49c0b3bc637012a152976f049b1c729d0b54045242297b478"
    sha256 cellar: :any,                 monterey:       "b613fb746aebdb23181d5e3705aacbb2106cf70925a92ab7da4c7c3f87dc988d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa97e57060c09dbeadaa0822a0706994eaa65ffea5c5a898a78fe39db55a32c7"
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
