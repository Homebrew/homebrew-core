class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.1.11",
      revision: "9144684df98ba7b689c9a61da5a57c0898aef035"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ed1ea5cc6d7192fbfa07d4a16326001348152c9a0afc5b0a4bbf8d8caf6a5b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90d7eedb913ddade2c3afbd2c035cb7a05c692355ff9ca215937893491986095"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cdcd8f20d050e6528107eba570c0e8c2897127e30ab86a5f2e0de09ca495586"
    sha256 cellar: :any_skip_relocation, ventura:        "da1abff84eb066f5c19411f8c1f0480af45e0f106e991ea8f3b12d124abfb93e"
    sha256 cellar: :any_skip_relocation, monterey:       "72800ebc7f17b60f37af34a47ab44dbca1ed86f5b3c83e393d393cf012118a6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4380f28b433b628a6b2937d852d27d93d530f0a52e2d9c6f763ae52aaa2a6b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6657af87dba22b6bdaf3c576f47d8b692807a47680cd074f3d0a962f8a5a6680"
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
      ASF config files should be placed under #{etc}/asf/.
    EOS
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/asf")
    assert_match version.to_s, stdout.gets("\n")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
