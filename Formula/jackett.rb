class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2688.tar.gz"
  sha256 "456c77e882625a3ef9a4e0f07757f9d46e6f09a2b5bde8965268f6edce4c0504"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd14ad1ec6dc5b486d8b3e73a8b1f69631c335386c89a749dc4509183df1f1bf"
    sha256 cellar: :any,                 arm64_monterey: "fc1ade9538134801fd90254bd1427b045615fa90736d5ecae6ae2d3dabc25c1e"
    sha256 cellar: :any,                 arm64_big_sur:  "ce84609b7e9170415c51b6821099d124fbdd8665736dc473b1ab735b35166dfd"
    sha256 cellar: :any,                 ventura:        "eba71d808dd8d6ee188c0db011b7c709a8960b4088113280be938f3a54e38db1"
    sha256 cellar: :any,                 monterey:       "447116c20967bc03d60f13b329b5bfa3e2705868d1ab909c6497924df218cba3"
    sha256 cellar: :any,                 big_sur:        "620a12c2a68b5f9e70d5809a0ec19f51f2ba4ebb54038474695e5ca9fb2f3462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c4e87159a11e5e9b979a337f1136c2d827a8751acfa485f34eeb4bd837fe2f0"
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
