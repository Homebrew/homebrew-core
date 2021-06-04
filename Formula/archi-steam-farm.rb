class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
    tag:      "5.1.0.9",
    revision: "31a06a8af36360c0f2afaf1bc3e41fdec6d2831b"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "6f72a4db25f8b58fefe7fabc8034ef704b77fb540f0aa3bd8f7fc1e74a5e37ca"
    sha256 cellar: :any_skip_relocation, catalina: "c1f20920ffb4e536bd21ced34f49d4a187e8235cf0d276070aa19c636a06183b"
    sha256 cellar: :any_skip_relocation, mojave:   "79bfb2af406046264a62441ad89934c37015585b29cb99c3b99b2328673342af"
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
