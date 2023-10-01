class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.70.4.tar.gz"
  sha256 "0e986e5c46504db53da73711e7922c3ea8fe6fa80aa818fce2eb3370e79ab7c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23319a6fd07db42c07d30f49d9d19b4fc428232a6f1caf75baf0a080a20d3a77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b0b3aef94ff0fa317a328bd5b391d2d61028a3373c3d5f67ae29ec7fd3e7b19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23ce420b8fb600f004c68758e59e073ef340f3153bbb6c6b6ad379f80c5ac5b7"
    sha256 cellar: :any_skip_relocation, ventura:        "00b513fd37e1a146064c0de1a2ccbe027a1a129679e325598a75c634ba674b74"
    sha256 cellar: :any_skip_relocation, monterey:       "8ef537046d2e33ce35775d32db2d17e3892b5624e8ae13f9d529ee31ce937bdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d757b3af056df7c9a9201eeb83062187979c048d374ca743e7d335661d3fb3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "900fd346df10821bdcc586ce724ee128aaf4a328084a99e802dba9d9e6487428"
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
