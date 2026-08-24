class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.3.8.4",
      revision: "d8612e2dd323abf8f93eae55bfb5badfdb086079"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df1d08d857a1bd8759705238e85ffce1ad0021d320a03cf7bdad49718a618950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f26a3409d98d9e082f75b923feec6d5c47a5dbcb87a7c710b1d33f28dbb652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14bb3268bbb845ce6b472f7a8eb36b8038b54cb358a45c12b6375968f02d5a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e0dd57cc82e441e1dd868d3de49b052a742f8144bb4d1c3d720364b5be27be0"
    sha256 cellar: :any,                 arm64_linux:   "9e673c9099bafcc57244dd3f7a651800a11cdad92032735d3d2926292970a729"
    sha256 cellar: :any,                 x86_64_linux:  "5374026190c33d82e52e5ed6dd4d2381e8c4d65b1b8ee2e1ca729b4cfe171ded"
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
