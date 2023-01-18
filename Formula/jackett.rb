class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2670.tar.gz"
  sha256 "9c2856ea79a7e92789c909ad5b45258c26791d534f14497a6467273ce4c2d7c6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a6d529ff0af729f3404432f6badebb8981ff103ab2b885b596a8628cce543197"
    sha256 cellar: :any,                 arm64_monterey: "0c35512d205db55163dd7c67772b50ae7a127c1409b313f93bc4b42b06de8e27"
    sha256 cellar: :any,                 arm64_big_sur:  "c75e6cf1049059a16b0f55dc23fef7ce8def399e3deb319ed6828e04a8a1de33"
    sha256 cellar: :any,                 ventura:        "d57947824486dd3fff39de9082b38c7bd30b1737c4f797c1fc6ad3f45bb2be6c"
    sha256 cellar: :any,                 monterey:       "6bf67fa6bd5ee539fbe5e1ed427528ef098501aae07ca110c692b649ddd4584c"
    sha256 cellar: :any,                 big_sur:        "d6af53258571f943b7710a7904270706bc9ff5eff69ba0673eab2d7400bda7fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e47572a6d3ad6eb1b9d525c49cfc17c664212b5c7092fe992f705fe896373a1"
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
