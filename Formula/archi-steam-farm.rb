class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
    tag:      "5.0.2.4",
    revision: "08f35dd6e36a4d847a555405fd7a0242cd56fe4c"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "96264a2bcb5494cbb9cacfb2a7ee46e70f75a594699938bb6a762fd7be92dd74" => :big_sur
    sha256 "774eb7f137b45fce2daf728d5a0dab6de159a9bf99c1e3dc48735045ff481f0c" => :catalina
    sha256 "9126e87d0afe22979e67471b5b786309979160e0759a907a0801ec7b5f3f9b01" => :mojave
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
