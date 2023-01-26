class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2707.tar.gz"
  sha256 "4409e6d1aa4d56a6fa894c206d66e0f40bfcf3ee3b264066e05aa63ac45bcf31"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d2eaf1b0198fd97275a2ebd4e245501013cc2f7c3f116750ed863aacc404e8dd"
    sha256 cellar: :any,                 arm64_monterey: "cf44d62e6d08d24335bd5dc2c391c935abb67f2bf21a692f54b790d2d6d1511c"
    sha256 cellar: :any,                 arm64_big_sur:  "7d1aeaa16d7ad122ace51f0b2f7d0a24c2d23f36ffec60c9bfed8b0da66a1e4a"
    sha256 cellar: :any,                 ventura:        "6fbd5379a5bd0388500aa5953f3a1af634f1387c6b53c8e9406feb1c4c4ec058"
    sha256 cellar: :any,                 monterey:       "d49b9c07ed122227e1eeccf4ccae547630ff5230fc81e343206a6b54ddded829"
    sha256 cellar: :any,                 big_sur:        "bb6dd8bd8e92f26762a3d1dab84dd47fb1039bfbf694c6395a486cfa0849b663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd4f801a73e27fc5a29cc923a9f13a1ae20d480b8e2d6165f0394affc14894b8"
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
