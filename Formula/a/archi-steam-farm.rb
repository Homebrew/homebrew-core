class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.3.1.6",
      revision: "c89cdbdad9cee8857f15de810cbfdd2aee514404"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a2d1dccaf42f6f832a4564e2c6497804aa16c4fb147c7e77a119331ad960790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65666b1e1069e84063e8e42938a25354c37dedd79ed0805a26eacb3067c2ffe1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30ed2e06fc2c1ff40ee2a7d15d10f1324ad96d36bf247d32120b0d9b9b26a90e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7851733c0bc76139db47845afe5443a41b6e61fe868e580b308b495bc273cb77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c40d91e293d6d72e61f868833c111c324eee50341630408fbd01a7e803d974d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e86e539d0d0480876ec438520e55ee518730dd263e475558f5c0f9a3ef2e694b"
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
