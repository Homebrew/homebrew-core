class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.3.7.0",
      revision: "a8996a1f0689510a8c4e1f6744e5d08b2d6ac5b2"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40ad64ce9c3515024c5a93c875ae21594071d66f1c514d9cbfcd74fa3b99b674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e56bb689d3eda19b8779139f015292e6db65a1d5eb0be487626cb0638114d0f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5caf24b01a9f25438db6c5ca5731c25d1e8525a53ff1c589fa787f91fc0274c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd002d1f234e6c54ef24e43b48dfad73cbbc3386f433d4a8eb2578dd35e37586"
    sha256 cellar: :any,                 arm64_linux:   "6a6352fbd58432c9f33325e7086fb7fccd2cc0dddbd03d775001d6cc6820c616"
    sha256 cellar: :any,                 x86_64_linux:  "b597ff5e1bf145602e0fb41b84ac5adc6078424c276db584a388a0cc3a6a7e1e"
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
