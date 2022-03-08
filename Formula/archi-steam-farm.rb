class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.2.3.7",
      revision: "d087aacbfbb4ce13e4ccdb852c3a58a882e9cc6d"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69e021c8cee0678b4bcd3cc76f909749166b1eff05f6ac3cf6d9b765706ddf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b69e021c8cee0678b4bcd3cc76f909749166b1eff05f6ac3cf6d9b765706ddf5"
    sha256 cellar: :any_skip_relocation, monterey:       "953eed46075e8b5a5f8161f042b91274b5fca3bb74145661524071399561d8fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "953eed46075e8b5a5f8161f042b91274b5fca3bb74145661524071399561d8fb"
    sha256 cellar: :any_skip_relocation, catalina:       "aba5fa04a3c638461892d3c94352c7be7f2e9e9c736ea87507069ca3c60261ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a35d7b03d16e59f2e37c2d6a3d76c72476bad9e57340afed23f6987d15c1987a"
  end

  depends_on "dotnet"

  def install
    system "dotnet", "publish", "ArchiSteamFarm",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", libexec

    (bin/"asf").write <<~EOS
      #!/bin/sh
      exec "#{Formula["dotnet"].opt_bin}/dotnet" "#{libexec}/ArchiSteamFarm.dll" "$@"
    EOS

    etc.install libexec/"config" => "asf"
    rm_rf libexec/"config"
    libexec.install_symlink etc/"asf" => "config"
  end

  def caveats
    <<~EOS
      Config: #{etc}/asf/
    EOS
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/asf")
    assert_match version.to_s, stdout.gets("\n")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
