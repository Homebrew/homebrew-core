class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.3.3.3",
      revision: "dd101c5096d2949ea146c138251760feee36923c"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "945d083501cb01196aa1227b377f96285ab8c892137cc552aeca3071d622abf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8105c200c966bbfe946768f460b4b4c96d2814f3e5d6318bb258633f23559bd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4393fe45275f8d5c0c0d3b7045efc15765d78f86dfd2aebf6ea3d93cea645cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c23baa695e1db0f4578020d5bb97195c2ac100dedc9e47014dd7649da964b51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ff6f9504b4a86474b54a3ca9b943e43196731e9cf5aabb3672a1448dcb737c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e29e93c47c0682a11d4606a87ca721c4faf607c0ac3b29d5e2e8353e8e3225ff"
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
