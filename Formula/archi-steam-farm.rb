class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.2.8.4",
      revision: "feede84577362168b220f01676b9868c3fccb1ad"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6929540fb4caf8cae82e5ea5234dfd40845d74d2310ae93419c26a31263842e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "702dd2f0cfd0edee985f3801af594266b7ce0bafa2e2746d6629afa265d4587e"
    sha256 cellar: :any_skip_relocation, monterey:       "d4ad1791c32dde8dc0564d9fd7413e148bda75344afa78f6efc9ceb6545ae817"
    sha256 cellar: :any_skip_relocation, big_sur:        "879a30dcc5c4b077e69d7006daff954ca09f7f6e53e482d7ae141f97cbf0bf8e"
    sha256 cellar: :any_skip_relocation, catalina:       "35e5ccabbd7189aad4b9e88657e6dc8cc632ae40114c6691329a8b0f790adbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af817881cd3af2c390f406570f8098d33b2b038650d8e7df5a4ab38a2502cc1b"
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
