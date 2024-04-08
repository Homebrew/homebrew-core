class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2324.tar.gz"
  sha256 "5531d996a69b1581b679f1630e590ae125ad0666a46a30fc046c7936782d1167"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f2a37f34dde1b36a6a2d89219050e52f2b6b9e9423c7bfe30e722581a3b7333c"
    sha256 cellar: :any,                 arm64_monterey: "4fdccb5f6decefec32d34f8f6e723a847f7408556dd1943c91967231ea76b8d3"
    sha256 cellar: :any,                 ventura:        "39db64fc23367c7f7e68680745a3315584147f493fd53153f5ee3cee8d43d9ea"
    sha256 cellar: :any,                 monterey:       "a7d00a524d38abfd102914c074a0bbf09ed41ddba613f3337dd398c859c67fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "225c34f89fe741bb69dc41acadcb4dd103f9195de01ba96296924cfd02013f34"
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
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
