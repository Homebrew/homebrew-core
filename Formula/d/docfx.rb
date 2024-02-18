class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.75.2.tar.gz"
  sha256 "4ec0ea2198bf399f1cc6db807cc2aadf6e1cdc42ed2f2e3a77ec6d21b4f9efe0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f2224fee59e01fbe37d0e0e78fae3ae7e82091266cd566ab21cb983763d8714"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f211cff6f1e975297e55a23ee671f3af34626faa28ae637f6e601be7a1f15259"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50eee8dcfdf3986dba32a5bfec115d12b7598f3107b67d3195b6ab3805a39a3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "49fe6899ef113b0e4982bfa8e84ac9e46e4460bc86cc4843bfac4803fd801ada"
    sha256 cellar: :any_skip_relocation, ventura:        "928fe973fb355aa1adc6dfb9736b69fa08cf0519eae165692e2b5b7da8de7f5b"
    sha256 cellar: :any_skip_relocation, monterey:       "50e97fa027500232ebcdf2235d52aaab261f5d5e455a6db70cff3c17c5167471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f70bf4213580e7d2e60dc614eb4700d67646aac926c9fbb01409b709c56eca7"
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
