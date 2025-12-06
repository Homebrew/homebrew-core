class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.3.0.2",
      revision: "252e498d8bdd7dd48fcee8382421875e9db5f9b3"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56ec334ab300d981a48e231f1dea4bd7fb5e4881f9e09aab51d82fdd284a936b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "490c297bc91584818ff21d9a26b7f750729bf81626aaebdf913fa2be568b32f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81299bf6abd6721445576143caab857d9242158c11d5dcf0ef7f2c28b612c8ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55e45a5277ae05dfc01d73366058c3e92c8626740ef408d95a899fa1a5d5924f"
    sha256 cellar: :any_skip_relocation, ventura:       "36bce8cdb65d7803ef17f1bcaf274ba9932a282360ba92b2f348cd6ab49a6306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aedf76ac040d42c592fc6487e1a05515ecdbdaea434c7b95081451d7192c22c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eab4f0727c67da321d6322c4f30e538cd1f21743eec92700ceae659707d9b69"
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
