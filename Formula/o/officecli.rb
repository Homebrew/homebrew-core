class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.151.tar.gz"
  sha256 "ba46d6c5a46a3c69433a550fa5d2e2cf1b44e3c09cfc84fe09b68261b8459912"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "30c32092d9ead85814fae998924d58cadef45a3d27986cd4e4982c95107f6538"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37b650e6941f9da0ddff1f0fcf52a58c6f5fddb1e4e4b96fd6c6d469ecc161b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1569a0f60591564c9dda9e9b4a5548bb5bf52c32c01c587c6266c01d145bd998"
    sha256 cellar: :any,                 arm64_linux:       "9fcce5a394e12eff970eb5850d857b943f99318d59558921ce257ebc667a5200"
    sha256 cellar: :any,                 x86_64_linux:      "cd7f82e1346fcdcb807379c88d7d0b05a56bdbfd3a4e16184391cf592f018131"
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
