class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.100.tar.gz"
  sha256 "749df4cd136aaff3496f9a2ba87bb0a467963ad266c8361222c67675a183a562"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2142e05b7c0ab6765aa3d37852aac15791a94a27599e75f5e0e5b4061c1fbb59"
    sha256 cellar: :any,                 arm64_ventura:  "1aa26699f825fff1b4c6055e2a872f895a58575f7e11870bcaa5edb635e29eee"
    sha256 cellar: :any,                 arm64_monterey: "52e4e070d048567343394d7f9e66c27eee704cfac5b3bb064a237dc17c1a02cb"
    sha256 cellar: :any,                 sonoma:         "2a22ac0af0357993f1271993593dc2c897e6e7f8ab11317874617ebb349cc75a"
    sha256 cellar: :any,                 ventura:        "4f5653348b17dc967b4dc534a4ed2d46f829fac53ef42aa5fd5fba6f0a18a3b3"
    sha256 cellar: :any,                 monterey:       "3d08104ea3eb4b78100ce4a07a8cb0ed12e65034276636dbcde591f8603eaf91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3da022621d548579c19633cd4d7bab20c2d4e35ee2c131e39ba9bbe017f96449"
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
