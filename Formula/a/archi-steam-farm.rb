class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.10.3",
      revision: "f2563c582c45847c0f3c6175075785a0ffd0f3dd"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34026fa3ddf22c225705c554b041dd26c76d687b76fe105106d6df5b41b73632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d295859055d410efb4a4617a8be289735cb441c9edc790d89e83205fc850090c"
    sha256 cellar: :any_skip_relocation, ventura:        "35246ee1bfd1a485d32317390ac7f2e0bcd10b1bd5144cbe69d2213aa65e95f3"
    sha256 cellar: :any_skip_relocation, monterey:       "cb9a0be8dc42a97ba1ef04b1b76d2f85808dd05898b36c6d35b0249423e5a18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4767aca0cef61f4e241a1555b4bbedbb8b662c27d289a53e652f1fc1db6507c4"
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
