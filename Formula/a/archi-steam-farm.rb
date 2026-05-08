class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.3.5.1",
      revision: "dbc295c4f5369d59a9c16ecf2c37faa66f87eae5"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c1a752a35bb821610420e76a03554b4815b9b24194fe6b6de2d40eee8ef9e84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5538fbdb9d9406026a9f3e04be5ee9a63bcd94d82b08184c518089ce07c74cda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1aa5079e62791f59a3e432febb48eb45bcea9cb45edeb9b1a911321c8b5dc38"
    sha256 cellar: :any_skip_relocation, sonoma:        "21c2b2282374ad3a6ad3e6562c55a32acba181620380e48bd71bec00f20d54eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72d5c6734e2ce5da4b97cee8cd5e8ee98c46467719beaed5bfaeb424134e0285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7629f3e8fab126be1fab24b6283dbbb4cd8ce07680d579516ae0c795c9db7bc8"
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
