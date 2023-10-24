class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.72.0.tar.gz"
  sha256 "6f80a9e5cb364ace579721866808efef5acf8433364cbea90b7e057125de1d8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b489c732cbe0d3d89311edf60e807b8f7174e1e9304da594b0afb87f3e5bc49b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d19a16f65021dcfe64a39444ae3a735cba1deb27bfeb3bd93caed82ba78d18b"
    sha256 cellar: :any_skip_relocation, ventura:        "43db5a655e863a70dd66052d035bf0421a25b9115148e13688d232f60044e833"
    sha256 cellar: :any_skip_relocation, monterey:       "9a3a9a9fa8550e3e89d0b1b4fb032060908954777dece8c947e2fe1c115fe402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "720ed02cea63ae7469f4ab7250556e12ce462f53d05b635fb6fe498ff44bc8fa"
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
