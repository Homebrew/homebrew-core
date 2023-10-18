class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.71.0.tar.gz"
  sha256 "3423dc8b24d9271b6c33da93374e4682a311cc416b4017cfc98cfe553d6b1997"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "694be96a5ae7ba8d41bdfe23b9c7043ad58b885d16aab251e450854b6c2fd31c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba03d7df58f592690e13d19d447819c0e9b65523dba260524c3f7b4551ede165"
    sha256 cellar: :any_skip_relocation, ventura:        "6824afed33c3abe89d55e8e24eebd95bce7a490c8b5a80e06778cd8d987eaf9e"
    sha256 cellar: :any_skip_relocation, monterey:       "b5e3c7a83dee8978e981eb98947b94b4f7653355fe8c7f8424ba79faddd4e8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "395aa82bdb6b92ee578cc7af66fab0098fe6891d1ccaf21aa7ddfe788f58898b"
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
