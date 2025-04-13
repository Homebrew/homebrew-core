class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.1.4.3",
      revision: "0b1ddd39d500c39103d7fc68d23e62b74067242b"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "151e2c879bcee6f3fe52a002953f7ce2e2d858d99531bf654fd4106fe47d0306"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b520bf5b112c4fdd1f85537916e80d036b78e3f186cc1024083049577f538b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a2e69ceaee79824ef8f21be378638c7fba4095aae9581d1638c08a9d41249c3"
    sha256 cellar: :any_skip_relocation, ventura:       "19c06079e248c34002ff6535717d91b7d48948e1269252c27d9e6566be8f83b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30b3952337eb0e188c5918f190c134ca3f7ab6b39d38051c67296708b18fd0f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42b96a4245b5f42d8bde956b619983e6c096375dc8dd5d2d685195f723ccfd4c"
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
