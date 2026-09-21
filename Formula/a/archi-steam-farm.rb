class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.3.9.6",
      revision: "e8733970dd9a240ab357ab85d2d7155b6ec0427e"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "afe8ce9b6e666d4aa922d7c988855dd9604619e7bca01b4a53c0ae2981a8130b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91f7b543782cdf86f4b0a3bdbb215287f7a3e1f85d6eccc1529316a72a964be8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4819ee9cbae68467af3063c5973d940aa579db7cb81bc0b1b1320d7db9f53807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "3430a9ff96d501a41c383eef3d5edba8b22f8b51d280b6e3462f70dd7e33b702"
    sha256 cellar: :any,                 arm64_linux:       "ccad4f1dbb20ce658740894c47eb65b71e61bfdac14c81c6d0f6257b4f2578c2"
    sha256 cellar: :any,                 x86_64_linux:      "4f90f37c7993ec28709db6e46eef98a8d475d8cb99d28b947a0d6b483744e8e3"
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
