class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.63.0.tar.gz"
  sha256 "78b244b7af1c056825f603ad6364dd3576e7ff9baefffd7c0f4ce8eb905c9122"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7769059cc148dd0491a42e7b90dca185d983642c56817eff379b49a47ed500b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8706a4a924e2c7587839a3e93e140ae856b87356e30f936503fcf8eba8f6d507"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e46c2ce35dddd728916d787bde1c80391135aea00d85705d7134b304a3bc129"
    sha256 cellar: :any_skip_relocation, ventura:        "ce51dac60c7fba200cc4cafe6a853fe077e901a9b5a6c140fee1e4c58dcdf600"
    sha256 cellar: :any_skip_relocation, monterey:       "296992cc630a7c81afd04b3de9cbe0b5200ef84d49da5a5ae823ef752603e975"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5a577720ce8801a0670fdea90a95980a695d4039bd37f9547bec9f85eb16a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32591943dbd86eb1d08cf1ef0e044c1629762d6e8e5ccaeca1231c4ef0bc837a"
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
