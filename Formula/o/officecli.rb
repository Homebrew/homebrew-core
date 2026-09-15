class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.150.tar.gz"
  sha256 "c0739e37e6104fa10e539d1f7de6262ecc54ca817938fb50e1289f1ca22b5d9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99ef64b9b3a7e3df021814e59dc87f0a403ebeb7a5b7b3785c8a980860c356f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e02e84c8fd7ea3ea54c7d0c95b842444f31db9dfcabefbab82c0aa7f2f138074"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e465a854583e0fdf7051fc14fd0a1b51d3d5d2f1433521bf3318928a09490641"
    sha256 cellar: :any,                 arm64_linux:       "6f2a197f835b8a36cb5adb4b3394eecbce63f150827cc3ba9ca0256ab9c1634a"
    sha256 cellar: :any,                 x86_64_linux:      "ce16d17ec4bde2fdad36cec1b7ced9e30592738667a5de904f8545a1d755fe62"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishTrimmed=false
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:Version=#{version}
    ]
    system "dotnet", "publish", "src/officecli/officecli.csproj", *args
    bin.install_symlink libexec/"officecli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/officecli --version")
    system bin/"officecli", "create", "test.docx"
    assert_path_exists testpath/"test.docx"
    system bin/"officecli", "add", "test.docx", "/body", "--type", "paragraph", "--prop", "text=Hello from Homebrew"
    output = shell_output("#{bin}/officecli view test.docx text --json")
    assert_match "Hello from Homebrew", output
  end
end
