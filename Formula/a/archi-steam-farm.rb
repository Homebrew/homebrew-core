class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.0.3.4",
      revision: "8673ef842036bafcb2384058e43d5e31c0dfd34e"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d4e1f46d49265fc769c22cc92d4e98370bbce01504910e8fd8b705841aad8e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f54f16fea4af0716441f3894ce39b4a7637c376882e0e7dc9a1f00cea92d5e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ee2074cf035013b94922e63b67aadd5b30703e0a616979a1ef8c54478a4a4ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "dce80a1cfad291a3c15a17428e86f0cf975ba7468b4813ddf3c1028ed1141e7d"
    sha256 cellar: :any_skip_relocation, ventura:        "8ffec1f0c694cc157fa8c3dc19bbdf0d42ece93f5a0a9ebc0d89d4b281ea82aa"
    sha256 cellar: :any_skip_relocation, monterey:       "ac3060e74733136b0608065ed2fb0929dbebc2c4bac1095556c317fc96b6d219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d15fc12e0a68558e72db2ce83b589600ff46c334d516818cf8edbc029deb0dda"
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
