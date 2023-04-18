class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.63.0.tar.gz"
  sha256 "78b244b7af1c056825f603ad6364dd3576e7ff9baefffd7c0f4ce8eb905c9122"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "556c1d067c96620e57dd2babbc44aae47c81307ab2f708232455c14abdeddf50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6d2b0157174e85b9d43bd3a07ada880faca637a632a9cb131ba9ea769a30c5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1ddd6630232bf54599ba12f3c95059ec85c25eaa46b54a9ce0cad73d62ff685"
    sha256 cellar: :any_skip_relocation, ventura:        "94de3923426b9f1ac19fce443e0f3426a99f499aeb689103b47c2df291227531"
    sha256 cellar: :any_skip_relocation, monterey:       "e5124890a8fe533417b89475a0270d5d6c364c821d482c72a9f71e4ecbe7abd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "39e162cf91d2bf849f009d03947de2a57aae20ab25db749934ec2acbaf570870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b50ef0c7be24a1bbd06f5fb242d93033be8cf02ac398dc930f52068f1df520ff"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      /p:Version=#{version}
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
