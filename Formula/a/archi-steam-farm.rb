class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.3.6.1",
      revision: "7ef70a4083355aad917b9c7d7985fa1ec90df353"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb4ea2dfc92a38a496202eadd1d9a0cabddb75b7516276932a64aa1d9521977e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d03e546fb7494544325736ce4f7e31e01697c7705e0218366d7cab339fa0fe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef60818df139ac1173e0f40069f41df4ac74efa7917a186612f9bb43469a6ced"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a77ac64f40dd73f7390c07221e93270a11bca33d4fd03c008819a71de58e7eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "538af342579764151a5b3508d1303ded976b9704badd691c5e0dc680948aef23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f086b18ab69b00ac4387567a3d76a10f5d7baee2838611d3cd44c37a0e58208"
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
