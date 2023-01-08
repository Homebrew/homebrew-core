class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2593.tar.gz"
  sha256 "7ddc085ea56254830ce2a5448fb5d5d59124fd9dc256346ce78cccfb4f8151d3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "436e6fda5c2c2db06947b8996278fc72beb508a70a8abd363de7c34780243419"
    sha256 cellar: :any,                 arm64_monterey: "c9113980ca95af06bd1055b62c3ef714cf60e885142670cec18214d80ccb29bb"
    sha256 cellar: :any,                 arm64_big_sur:  "ed2acebf9bf78479d5deeca2b52ff78388d9b09e385ef03f50f5fb8988f066d8"
    sha256 cellar: :any,                 ventura:        "2a14a9f7d49d2ca3cd3c71ef66dd7a446676b5858bd2e1ded003340c85a04dfa"
    sha256 cellar: :any,                 monterey:       "2e515505ad8fb54b9cfb5acfc56f7893e40e8cb4f3d0799c26c47f2a243ba427"
    sha256 cellar: :any,                 big_sur:        "5dc269bc83bd7d309121b3b2154db13d2c0c6249ad2440cb6d32c2ed26217c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2af32242384dc7bd83ef0ad3a69df73915ea0c796da08b48687c75376ce0441"
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
