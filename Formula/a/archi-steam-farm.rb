class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.3.11.7",
      revision: "6dca024487b9cfe47fc8cc86a38d9dcaa17f5cc8"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6ea7d56b5af0b0fce8d6f2fb46e5de15d59ab70c71328ccc1e3e2d061c40644"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a8940d885045c8a585684277b77a47d098cc2d4cf9637f870a92c6daaeb1089"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5889d9110decf302f8abdef2e47f1435fadffc75b88aab1cc16bea025a783333"
    sha256 cellar: :any,                 arm64_linux:       "986ea66238248fde511c81468606f976499247ba57f640d2db2082ef30c33f45"
    sha256 cellar: :any,                 x86_64_linux:      "a299313ba33d333ced3c031c7382f9fd2b6f64a44b8a57dccc6145f86e4c9811"
  end

  depends_on "node" => :build
  depends_on "dotnet"

  deny_network_access!

  def plugins
    %w[
      ArchiSteamFarm.OfficialPlugins.ItemsMatcher
      ArchiSteamFarm.OfficialPlugins.MobileAuthenticator
    ]
  end

  def dotnet = deps.find { |d| d.name.match?(/^dotnet(@\d+)?$/) }.to_formula

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    system "npm", "ci", "--prefix", "ASF-ui"
    system "dotnet", "restore", "ArchiSteamFarm", "--use-current-runtime",
           "-p:TargetFrameworks=net#{dotnet.version.major_minor}"
    plugins.each do |plugin|
      system "dotnet", "restore", plugin, "--use-current-runtime",
             "-p:TargetFrameworks=net#{dotnet.version.major_minor}"
    end
  end

  def install
    ENV["XDG_RUNTIME_DIR"] = buildpath

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-restore
      --no-self-contained
      --use-current-runtime
    ]
    asf_args = %W[
      --output #{libexec}
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:PublishSingleFile=true
    ]

    system "npm", "run-script", "deploy", "--prefix", "ASF-ui"

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
    Open3.popen2("#{bin}/asf") do |_, stdout, wait_thr|
      assert_match version.to_s, stdout.gets("\n")
    ensure
      Process.kill("TERM", wait_thr.pid)
    end
  end
end
