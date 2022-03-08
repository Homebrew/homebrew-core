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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dc6c04ea8edaa8abc72ee6c3826d8012d0cc408faee603913d808ff8cd482c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dc6c04ea8edaa8abc72ee6c3826d8012d0cc408faee603913d808ff8cd482c6"
    sha256 cellar: :any_skip_relocation, monterey:       "552ade464ee3c4cbe4ed5a1e60212c4caaa219305f1a79eb9fba911950f0da01"
    sha256 cellar: :any_skip_relocation, big_sur:        "552ade464ee3c4cbe4ed5a1e60212c4caaa219305f1a79eb9fba911950f0da01"
    sha256 cellar: :any_skip_relocation, catalina:       "a24ff31f83490176f36ad00a241c2c8e22da886b9f10b4d64d645fdd4642ced2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3111089086ca56ce00c77651e115269807c798e69eb2cb6f10e203df781a773"
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
