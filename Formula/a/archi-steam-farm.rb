class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.1.5.2",
      revision: "868d593c5c6115b8484771a9eb5c4ff2b5840719"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5ed61828efd8fe97c2ba8061315ea8d21f5ca98008b6c8c965e5452d5057f25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd9bb90ddac74429a62a2ec86e5387f77e1085b1e000f29dbe0392df0b6f85d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66634a8d7e971b0c0f156a024d934ad374761a4b87b8ca5c2b7deb8281cd14f6"
    sha256 cellar: :any_skip_relocation, ventura:       "a4d1b79b195ba95e7d6dea52b666b8e8ce8f8c2ff952a89aac97036ee9fd8f2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a933d5860142aad96c86565b30319191d085b79f499e1588a2dc884421a689c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1894fe0667f2c19dece079ef2895830e4dfdee6ab7f15651d0d6d0e36a014b78"
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
