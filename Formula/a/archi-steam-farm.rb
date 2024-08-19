class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.0.5.2",
      revision: "03a5853a91358b7e7dccc0c17f87f2b26e4f872b"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a0864824db6989bb0da80c239aa844c890688b8e119ae5e663493dccca7bc43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4adae81a2c25e9c3988013a610bb27d44b270814ad43c8906f16103fd5eb8b59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3852db6cc542fe5b17dd81567d8672675a285b27af1f003c9d52fcc10979ec26"
    sha256 cellar: :any_skip_relocation, sonoma:         "caf59bf9be59b829bd559615e2c369438e09459a144d57f59c8d1e03f46ba88a"
    sha256 cellar: :any_skip_relocation, ventura:        "5ff652ec3525a2d224afd3168b3ffd379b80824caca1f1820e5af7ff4c369805"
    sha256 cellar: :any_skip_relocation, monterey:       "ea363e87d3d0f7f902da4a389b86fe2e21f8cd3b36903904a93c843d2dbeb4ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89360c4b7ec016776e2e8e6ef25c72ca037f1e16167f464551d6750aeb7e3d3b"
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
