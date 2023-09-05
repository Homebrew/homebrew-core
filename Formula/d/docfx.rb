class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.70.3.tar.gz"
  sha256 "0c326d7ce7c9938ce717878675b38696b88020d94e8ef3e1ac85deb5c3abf604"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02f6df2b1b87ed7c88374aab6802e5cd61372d7238d24576ebae351b9c7fe155"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bce2405d2166d1f1223b129bbcc984af202da8b90b16aca991d51f1f7838fd51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "997d4ede80474b0294d2e1921ead67a66d23fa1ad45900b884db904f809c554a"
    sha256 cellar: :any_skip_relocation, ventura:        "0be2fce1464e4416db5bdd69c1398250dcea779bd390cf06eb5cf103abbb25dc"
    sha256 cellar: :any_skip_relocation, monterey:       "41dbdc7bd5ebf7bdfa36471d644c0c962e21f41eb558a3360c2cd586bd4ebc87"
    sha256 cellar: :any_skip_relocation, big_sur:        "35e4b051aec9973829a3ba5bbdd20c763c2838bd9d030113668122020598fe9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "972ace09a4e3468ae5ae06fd021c70b739796abbae7aacfc2597a08dfebe7784"
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
