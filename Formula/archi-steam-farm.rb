class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.2.5.7",
      revision: "7532b89fd02696aa680ac001df6e85ecbf114926"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52588fa149c88a4792e11126c4b539972202680fee34c884c5975329960d44c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cd23228e657e8ec75883dc0cf809b7c6ff44d7f1df987a31f21fa5954d02203"
    sha256 cellar: :any_skip_relocation, monterey:       "e70791726631128e107591942451783148e95c287c5c97327ea8b3ddd7b206ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2d49fb5e366f66b0b4339cc732350419f35270df05d6e38ca354376056b4dea"
    sha256 cellar: :any_skip_relocation, catalina:       "752f79cd2aa3831d2574a86d8f5322f68024ea83f89c6c222830231c12f8091f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e63d978a9bd51f7e198fa59e7dbe4a27b52a5126bb2eb8ec70064fb5cb2309b5"
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
