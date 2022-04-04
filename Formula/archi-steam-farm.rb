class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.2.4.2",
      revision: "aea7c7640c4b39e7de187a68d1a413c8460874ae"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1accef4e592ff0d817b56cdfd2e0a5d8e50cb2026ba5a2563a8603eb61b65f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1accef4e592ff0d817b56cdfd2e0a5d8e50cb2026ba5a2563a8603eb61b65f8"
    sha256 cellar: :any_skip_relocation, monterey:       "b13a21c309a475840bf326bf2218982ad86b0797e4c342d705607d0a7c1a3c4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b13a21c309a475840bf326bf2218982ad86b0797e4c342d705607d0a7c1a3c4b"
    sha256 cellar: :any_skip_relocation, catalina:       "efb1d8af377e14d0ff4bc482e37e59e219dc18fa7874018a8b01d9df5d9214ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5253ef3735381e38e0a20e4f6de09344f96495ef2aac29b2656ecdca108e166"
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
