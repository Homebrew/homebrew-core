class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.147.tar.gz"
  sha256 "de9ab9adf3616276b2fe394774b0802faf71d7f9ddf9feb32d8445a7cc4fb686"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59b27aef12919750fdcc347bf0c9ecb06b1c9b22701c11472b43fd6e059ab8f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "020a0de26a56b9fb7b27047d762299aae1aef68c602a6638c06b9bf3e31436d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eda5e4d9866b5aa45cdcdb2cf06c397024b7e19141d02431e160cee5ef1b613c"
    sha256 cellar: :any,                 arm64_linux:   "704ef1664a9ac97a47c2d46874acdc28a825ccba8377e6b7d90456754532aff6"
    sha256 cellar: :any,                 x86_64_linux:  "31c0263e392e50d21472a295cbf785eb82ca5706610866480d9b1076a96bf045"
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
