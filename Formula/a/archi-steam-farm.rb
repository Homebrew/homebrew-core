class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.3.4.2",
      revision: "4bbcf5ef97af8fce8f8c39e83a5bcd4ab316054b"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43b718dc35266c58bcb3da148d619b4d033efcf656e0d3ddf3467ac8d5d71142"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e2e7299fa97b7fc71b847143c385a515fa208ec3195019ad7a14066a0a080c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d582f7db8e733641f75c2c773924ca5ae98672f714eca17517a2a22614395d65"
    sha256 cellar: :any_skip_relocation, sonoma:        "2caacb2096bb0b18ab0f029eb7a18fca44e96ef73a042ae6fa3b86d939ca6e17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "889edae86f5375d11338651c5808f95cd7f62b2378ad49812be5f34b975aef6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18920ba85be42bc59c225af272ed72c7416f1b906b1913338308a3bb943b868e"
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
