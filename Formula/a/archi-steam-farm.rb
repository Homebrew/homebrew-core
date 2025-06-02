class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.1.6.7",
      revision: "5d4666d5381dd44bed65f2053a3ca703dfa26315"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54a69e57befa6291b1916a432f735a5aad188f16ff2df1265107c7b0b1546238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b958274badf0ad3c5e3683edb73d79f68d4afb467bd0f6bcd6f9c51783cc649"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc4534ad74e8befb10ba3eb0ab377ae29fe427af1c01fe4bea9d2a3263f8ee6e"
    sha256 cellar: :any_skip_relocation, ventura:       "a59305ef7d6293fdbdad9575d1c0d7325f7f11e1bf3b9a52f75103753c32d8f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87e812b180514a796a6b8b88b4796ffb1c654043828df11d033fa6b40fdce7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec47c69488b6cea6efbddf03f0203c4042b6f136f5aa0c6db16e2da37b2434d"
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
