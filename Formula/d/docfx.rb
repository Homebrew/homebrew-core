class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.75.3.tar.gz"
  sha256 "acdf37f58dcf9ea82554c641cd45914cb3813f6493504bedda1b5fb4e4390a3e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "008812a338e393dd04e61aad7471d0a5143dc7c675bbc2aa076e68683982f40c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41452127d5179917a1139a7dd5b63ce0e43180b16812fa77e69ab34654b624e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77fee16c78d260815b2b5629de6839b151ec5ec9679af949d624e7986541b8d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "be92896c4c84d470bf5fdf639dc4c471d5b7ea27bc5824e73c090288d983220f"
    sha256 cellar: :any_skip_relocation, ventura:        "6ba4023266f8b06ec030d5610753a53d34b758e1c08fe54ccbaba9d7953c9588"
    sha256 cellar: :any_skip_relocation, monterey:       "c61346dddcf9c7a8cf0f9a42851eb67075949371ef599bdc71c0b7ec6a7723b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfbc799a014006d5710660df9c9d5c80ea81c667c20093542690dec19ec1f01e"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    # specify the target framework to only target the currently used version of
    # .NET, otherwise additional frameworks will be added due to this running
    # inside of GitHub Actions, for details see:
    # https://github.com/dotnet/docfx/blob/main/Directory.Build.props#L3-L5
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:Version=#{version}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
    ]

    system "dotnet", "publish", "src/docfx", *args

    (bin/"docfx").write_env_script libexec/"docfx",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    system bin/"docfx", "init", "--yes", "--output", testpath/"docfx_project"
    assert_predicate testpath/"docfx_project/docfx.json", :exist?,
                     "Failed to generate project"
  end
end
