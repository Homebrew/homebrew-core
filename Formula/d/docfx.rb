class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.77.0.tar.gz"
  sha256 "03c13ca2cdb4a476365ef8f5b7f408a6cf6e35f0193c959d7765c03dd4884bfb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a7d1a6e441d983071dd1cb2f1a945ee55cb05cdb6cedd57d29a68c886794490"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be98269aced336adee7567f5bce4b75316b650595b2ff71d0059a259323b9ce5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6d7c94288c97591bea4b1eb37066663c1e1e3469c506babd95ea42fff52cf6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cbf338809fb49538a7d0776e571ddf58da4815f9bfa643209d5c68259b3d7d9"
    sha256 cellar: :any_skip_relocation, ventura:        "812bf6ad4c29682b276a1464febff524b0eff3d72482d3e55120613f4b86f3c8"
    sha256 cellar: :any_skip_relocation, monterey:       "d831a32f78422ac08b69b3458ab9425fb2ec7bf6d201742d927b8656a2ff478b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c55f049d46aacabdfd83aed28a7834e88c566f7d3f1affbad9de3f19f0e93217"
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
