class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.3.2.3",
      revision: "fda6b6929dab46becad5935ded1b1409f2da6cda"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bff1ff30f0a210bc670ff0bcd6b5d57684705332c813593a685e7ddf781336bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a19fe2c263d95e79ce89c8ee7f59600df36864b3e4c2c4579db947723dd6544f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b727a6b98a5f206b28a1ef796382ff743b62a72aeb561b0d0ab347804c121f2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "37b84a62c2dbee099f467f910a60c1f22fcbbc63f54f6a365061e1ebcc6197d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6589e63af362762d32ca79125fbfab536dcc42a6c34b40e8d6842ee91e2b9c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3549955369ba3270005105d348a03ed8b7e0c0f4cc2aa05d84735fc849cf0e6f"
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
