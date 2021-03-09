class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
    tag:      "5.0.4.3",
    revision: "c34812e4bc68ca53e690552723cddccf80e14a9b"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "0ba05734f4f927b6ebb873dfe4698fef273ab46f623878e29d852b9709032bf9"
    sha256 cellar: :any_skip_relocation, catalina: "72b940f1684b1e46088e83f032f2bc92b2d79d39908e3fe37e9c7456461fa0b5"
    sha256 cellar: :any_skip_relocation, mojave:   "8d6aca52f8cc198a2e866d1d348e89145d80cc65282217ffcd8ba34c8c975be1"
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
