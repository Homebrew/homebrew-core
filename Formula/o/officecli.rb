class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.161.tar.gz"
  sha256 "87d6954541e25fdbe56dce3328d497e6b397108f11ad0f1979818f4bd8a44201"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f5df536f5d85b77c49b2b62d319f7647516398d5e0553ebaacd086d9533fc86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf2404288fd0b595e876c40b5dd436d63eabd83c351170624479b290c581dbbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0b0bc8372e8f69ecfa369db67578508611b758a32ea81bc6ec9c210133d3dcd"
    sha256 cellar: :any,                 arm64_linux:       "42785e3c0f707ff8a3577104cc6694c6c88c92e204a95ed7d412639e49607572"
    sha256 cellar: :any,                 x86_64_linux:      "6bc6fd559051e698f23cb70d95b66cd20193481c0030f1390e7c5af3b47e967c"
  end

  depends_on "dotnet"

  def install
    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which build containers may lack
    ENV["XDG_RUNTIME_DIR"] = buildpath

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
