class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2489.tar.gz"
  sha256 "990eb8982f24a13532b4fc839fe8ba7631bcf7a0c5fbd426e864286888d72e70"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "77a35ab73f6e77cc8175a7596b31a23823fa1edfda727e2721aed3af4d610c73"
    sha256 cellar: :any,                 arm64_monterey: "bd3dc93f15e5fc3b1edbd63c8928f5563df885d05d197283bf0b928f8adf4d33"
    sha256 cellar: :any,                 arm64_big_sur:  "f7aed7e1d149e229cdccc28f3caf07feadfd954301a2d6c704d9efdfb18d571f"
    sha256 cellar: :any,                 ventura:        "bf13654861e57604a51c0caffd4526cfc4bead0865692c1317441e4f2428e560"
    sha256 cellar: :any,                 monterey:       "0e0ee8d18966c5e644c928712348125bf75eaff7c6633160850b47e8eb4d40e5"
    sha256 cellar: :any,                 big_sur:        "1bcfe7b3205a8174982fe24ef0cc96d8f54fcf06aba243460e51bcb7ed266458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a24fea92aee13040fc6783535ba98af33003b7380f99d4df3739106a6d8a072c"
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
