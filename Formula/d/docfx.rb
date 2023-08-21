class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.70.0.tar.gz"
  sha256 "985b7bc49c4fe02d920590107e1f2fe73bd9b3f96bf3cb3d1f8aa09188a32659"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e45da8277bf33a61d7d7eee3641ff8eda6fc1b85383f46956da72051f8509855"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbcce54f023a65bac48c24693996e9b3c86ad97fe090d6d2a8b3523aee290b58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f25d563de450b300259edda687f0f6c17ba368ee5b9911da400556aac23085b"
    sha256 cellar: :any_skip_relocation, ventura:        "c2f99ddc4bd049081e0e945cd25dafc282509a2a5648f54c1aa3d5693ddb2625"
    sha256 cellar: :any_skip_relocation, monterey:       "0338ee28b5989d6e97739fc85a40a8e726339f4b97b610b9cb9299a94029018d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ed39d8d2ef5a6e27de481a264d52f026bcb118772de50b693ac212abdc61e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b056e9a8a772b60f294631d82908420544f662397d0e3de45a5ada2740007b6"
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
    system bin/"docfx", "init", "-q"
    assert_predicate testpath/"docfx_project/docfx.json", :exist?,
                     "Failed to generate project"
  end
end
