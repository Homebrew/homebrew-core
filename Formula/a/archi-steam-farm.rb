class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.1.7.8",
      revision: "fc198d6eae34532bc5b8e569857c36f060600a58"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa787051dfff7c67a2b048f3aa2b1212289906f4a9d32e345845f6c7db67706d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b484bba422f2485157842adf227119448849544ce1fbed4cfcac1f0509dff5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b162256552ad890b8830a4a59585ed67f0d80820f667a119f5fdf695ce18ad6"
    sha256 cellar: :any_skip_relocation, ventura:       "0557f54d636356faea00d5e9db3b9f91452387bf27664cdbb7cc2f85f492934e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3810116d24f10d3e34cc30737e081cb3566bf6d6bb3112cc3136d690506a80a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd0024b3edfc330cb469ad63174368d1fef67f561bb098de2e03e3088b037294"
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
