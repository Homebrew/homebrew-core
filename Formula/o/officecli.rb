class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.157.tar.gz"
  sha256 "cfd858ca32cc3ecb51b16b882ab2614517921c4b141674b82b0883eeb07a3754"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31310d3327e167f577229d9440248323a8e4af812fd0fb4d099581d9c5679fdb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c25e47869469bb8770074ae139d49d7ed620b5e490d41e858a02bec3c1aeaa6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b55af05e445b100dacba37021ebd7c75ac780f236fe585da28a549fb2b30667"
    sha256 cellar: :any,                 arm64_linux:       "9f33a9832086895e0fa727014fa5f4e4d66c948c145cbb093f03fefc8fb73532"
    sha256 cellar: :any,                 x86_64_linux:      "8b49e9685e6cb4f579c6c9604a823aad1d6679166fa34fecd3c731c9d5096a6a"
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
