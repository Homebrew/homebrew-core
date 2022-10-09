class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.3.1.2",
      revision: "ee4d5561dd90064189140611d7a1065d653a00b4"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "327993e7afc86ce64a792abec480382bd093c829ce100d930f814ee53a3eebdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f722041477efd5a6a1b72f194c204a2def82c8d321c10483deec93b964c1732"
    sha256 cellar: :any_skip_relocation, monterey:       "3a04a935a20276fadbee76c96ec0295634ddb09a30ae5f5a55eba74d41a25d01"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eaa72d7ef0b81cb8991249d9ae2fd0bc95e6fee71052e66878661926019778f"
    sha256 cellar: :any_skip_relocation, catalina:       "ecd9a3c99de7f291ceb28b768ab66ad2a8416038cb8441a16867757a837110e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc12df6e306adaf19ce1370f32e4ccf57142c5d993ca6963b219e6441b3cf89d"
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
