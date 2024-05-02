class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.76.0.tar.gz"
  sha256 "7d5579c876b84b8e3dfdf5c36316a374357ec377f851a5a7bfcefbae83b541d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e4923b63afc49c5869556b82c5efa3b4f5b7e98b3e8050938a8a952b93de6d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd147d3cdf442aa326e9cf2858a33d43ba0830bfbfaca9cb0621c85c49bc846a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69902860adef94bfa1dfe954e8afd68e579b236baf03b4d8cf6f001ccea7f521"
    sha256 cellar: :any_skip_relocation, sonoma:         "46fcfd619380d5f602af50060f11173054610780610e53719cbee3d46b94c571"
    sha256 cellar: :any_skip_relocation, ventura:        "561f9c9602d09d40b07b41c23614d6a585aebf9945c3ffb4a53222d88aa440a5"
    sha256 cellar: :any_skip_relocation, monterey:       "2464d56fe6a107b3a19ae06b1637230d790c849b429e21885a9a65ff209c53f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be3ef2f8d123e023ec786d8c249e2ada81528115fd3b452d7b94c8c28c57396f"
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
