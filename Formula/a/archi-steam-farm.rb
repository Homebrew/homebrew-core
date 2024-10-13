class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.0.7.5",
      revision: "0c21c223be615717c5756381bcc8a4540f49a419"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4d235d12880bd46c98187b6d64fa14d2a3f238ab017517df0051762bdedbc38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "786006c54c47223b77363a9c7156520369d0cfa87591e79323639f2a70007492"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98a90606b045940c0f48a3e83d03dd4bdef62600077722810ce5f6e1b9c70e45"
    sha256 cellar: :any_skip_relocation, sonoma:        "60450975121177ca11b0ae7a241658eb18c3c57961a66464de3ab0b289f40f3f"
    sha256 cellar: :any_skip_relocation, ventura:       "770bbb5990f121e90e1041fbacc17fd9e4438242d81ec62b483664670b1c04ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccbf1671733728d8bb372fac59fcab1057b992d73d2624d8e6bed4f33093cfec"
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
    rm_r(libexec/"config")
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
