class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.123.tar.gz"
  sha256 "80a298430112d9b42e8a579d3da7b24936073afc03ea96eb2fa06e42e0c51701"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "768944559570d9aa5e09e3534a230ac75d069e1928ac8b65a4b13a2db4e31f6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "944dfc7f65762ca7cb028dafa9750551b51b4105e8c7b14f883d49a2d9fc27b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ddb16fe0d239ce54d5869c0704974435655106bcf37f55de094b3a89f659b54"
    sha256 cellar: :any_skip_relocation, sonoma:        "7acdcfc1fda30cae3664558fa196b2fcc7f5cd785a4bffcbb950af64d7e95686"
    sha256 cellar: :any,                 arm64_linux:   "e6a1fe5f3d462133b51d83f2200e430d6b5d8762b6874796e329593a8b5dc17b"
    sha256 cellar: :any,                 x86_64_linux:  "dcd30ab1a7989fe644fd124b9a14b876e7bb587187288837fad5ba6df6210a6f"
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
