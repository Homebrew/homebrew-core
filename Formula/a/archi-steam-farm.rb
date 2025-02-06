class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.1.2.3",
      revision: "18be38352f317e6d3a9c79640dadfc9dc096f861"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4efb8d32c2e38f0b12c162b98d5f7c1bc8ed90907ac9fd2048b2faa1d43ccc87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6271ccec3e7f8c3644d1a0d17191008fcfa75f00abd98f0365febf9969dcc66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74522c00642fb0f559dec7e53c75610cb2fdf281700eb7313f4c6ddac4230a6e"
    sha256 cellar: :any_skip_relocation, ventura:       "018d3183f7e8fcf585324891f7b26c392924ad15444defdf04fa60d66b2edc42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69bedd388c483b15fbf55e26824ed956da3537b8185bfd4f4d2be91bb0a6bb6c"
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
