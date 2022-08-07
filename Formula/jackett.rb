class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1606.tar.gz"
  sha256 "45036b3c0f4b26711e713bf37e4856ea361fb7fb354cf85a5736490e219d47ab"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2542df2fbab8a9afb97ec5b2a89b75a9b895b56defeb73eda3d638c84afd8daf"
    sha256 cellar: :any,                 arm64_big_sur:  "a093bde87cb7eba9a2eab5de8c36ff6b854de25cb7abf8cd6e095b0576171b5a"
    sha256 cellar: :any,                 monterey:       "3837f70ef08c93f45e3eeea8ef6728ef3838b7004079a3d9f68a6e295926b60d"
    sha256 cellar: :any,                 big_sur:        "5f19febd6a4d778dd55f5de44d2436980c15e9d3ed4b7b402c6fa3e516b2bf82"
    sha256 cellar: :any,                 catalina:       "bcb537a364b044d42e8d636ce2c14f9dd5273ef16045e1b102b0da77c7f86072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "958c85b32dd170d6166d7e0158a5460919a34112f29a2b0934587d72a3a60358"
  end

  depends_on "dotnet"

  def install
    cd "src" do
      os = OS.mac? ? "osx" : OS.kernel_name.downcase
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

      args = %W[
        --configuration Release
        --framework net#{Formula["dotnet"].version.major_minor}
        --output #{libexec}
        --runtime #{os}-#{arch}
        --no-self-contained
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]

      system "dotnet", "publish", "Jackett.Server", *args
    end

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{Formula["dotnet"].opt_libexec}}"
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
    sleep 10

    begin
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
