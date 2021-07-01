class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
    tag:      "5.1.0.9",
    revision: "31a06a8af36360c0f2afaf1bc3e41fdec6d2831b"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "16bc55a12a0957f01360d26ba97cf3e8970a11ae7563bc0ccda5f26b2a09f3c9"
    sha256 cellar: :any_skip_relocation, catalina: "8b6857a931593bcb24aee55236fbb7a9ecf5d5331ab732ca9530892206911ac8"
    sha256 cellar: :any_skip_relocation, mojave:   "3ef2bb7a15b61fd19ceb48b371bebdfc8ae04e1ec95e117c8cf9cee77025919a"
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
