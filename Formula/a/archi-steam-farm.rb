class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.0.1.24",
      revision: "457828260b319a2a67d8b4e5f535f04657e3f657"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d052f8f039ba902e3d108574363e0c46c23b6f1c6567ddbf0b6a40c3ce65b63a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3fd591b8550852c3d595c1d9d56042d7719843a5e0ccd062eb0f8c6c7b1c620"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23150b97a61e470ec72628f9b022b50366cfb03810bba69bc4554c52dc177de8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e9541819e6dd5ce7aa963e751d8c173244adfbe91307cd4c11bb3307a3066b7"
    sha256 cellar: :any_skip_relocation, ventura:        "cc6997207478c5fef648a8c714bf32535e70ebd4a672130e86a829cb08199d21"
    sha256 cellar: :any_skip_relocation, monterey:       "ce79b515b32dbdd316749dac8d18becacd2d3ae1e45ba4271a1e9688b98a9c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0936a709d92846d3b2376a0b65c8654056d590c4a7efc22da5b5a9eb8a552aae"
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
