class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2495.tar.gz"
  sha256 "a50790fc897f1ab0c5a4a8e0322ebdddf69ec4aa45d6e24fb4bbdbbca3bbdb09"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d3a123e7bc872d2c6c7be029aca335634156b49f6dab0ecc7f258ea7f3370079"
    sha256 cellar: :any,                 arm64_monterey: "18bf34d105d3b0aec3c7d258a65182c74296b087dfc4a9fa7f01bf99e6632bae"
    sha256 cellar: :any,                 arm64_big_sur:  "0df2132e5ba4629a7d8fffc9cecc62613190f6808642e4ed5348c446b67a5324"
    sha256 cellar: :any,                 ventura:        "08a8936ec4c3daae4e93e31475855016831afa0955bed9a33cc47fe5213fc2e1"
    sha256 cellar: :any,                 monterey:       "d4107e6a9fa9faa07f27eeda1cc1641ad34aa430ac0a3324f1e6a7dde5591733"
    sha256 cellar: :any,                 big_sur:        "a278daab75c6c394e87616530cb5f2bedfac0259b63b332752f15fcf77651960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b98dadbf32085820d6fb80ba77b3a647a82a64e601f83d2071bd1299e83b8707"
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
