class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.1.1.3",
      revision: "cb08e05d62c5ada9eb58c81c95b553226b685e6b"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "422e1c71df1c1cfa18717ae2c4f4b8f31d6d37f1efc483af2eac3bf1df7e3a75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e858cbbb18d1474eb8eadc3f97eef9c3c7e4395f176424c3c1fd9fa9466b52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23870bec16edb05d13e746c00f19c093ecb170f2fac15155e7203f336580c35e"
    sha256 cellar: :any_skip_relocation, ventura:       "6c4728a4534d3429aa59d7a9a22b3051d0842513112f8890277e229e51573fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a9a0b05bba6433dee3462029f226dcf94e0af3f7db38c426f69fa4eb5328a0b"
  end

  depends_on "node" => :build
  depends_on "dotnet"

  def install
    plugins = %w[
      ArchiSteamFarm.OfficialPlugins.ItemsMatcher
      ArchiSteamFarm.OfficialPlugins.MobileAuthenticator
    ]

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --use-current-runtime
    ]
    asf_args = %W[
      --output #{libexec}
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:PublishSingleFile=true
    ]

    system "npm", "ci", "--no-progress", "--prefix", "ASF-ui"
    system "npm", "run-script", "deploy", "--no-progress", "--prefix", "ASF-ui"

    system "dotnet", "publish", "ArchiSteamFarm", *args, *asf_args
    plugins.each do |plugin|
      system "dotnet", "publish", plugin, *args, "--output", libexec/"plugins"/plugin
    end

    bin.install_symlink libexec/"ArchiSteamFarm" => "asf"
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
