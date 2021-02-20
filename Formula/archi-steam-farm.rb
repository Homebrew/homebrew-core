class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
    tag:      "5.0.3.2",
    revision: "be2f59ef8855b498fbf1eb8a630aca0e65155412"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d3c0297e5c6df1759fda10f4716dc905b6c8ea0b133fe87fdfc0c58354446951"
    sha256 cellar: :any_skip_relocation, catalina: "6b2e173555a3a770514e8fef25d601440140691c03ddef2451e04377d0302ce0"
    sha256 cellar: :any_skip_relocation, mojave:   "987d25f184a1ca9b76bc619bb6bba8800d75f08402fd5de39d806b95b64d027f"
  end

  depends_on "dotnet"

  def install
    system "dotnet", "build", "ArchiSteamFarm",
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
