class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.161.tar.gz"
  sha256 "87d6954541e25fdbe56dce3328d497e6b397108f11ad0f1979818f4bd8a44201"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3343366cccc5be0fb45c5e4229537aad7878d898b60c1df09671530bd6a7556d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "438cd5e80551bd360b8c77aabe519227636b0e2537cb22bdf8ab8872ce410389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49e02b8417257e4916b03b152f95954770d21261ed3e8bbe87224c3ac7b1fd70"
    sha256 cellar: :any,                 arm64_linux:       "88ad15bba300c34028d9dd5b61ec753de35f55ff10df0f2a120f002b071e5b26"
    sha256 cellar: :any,                 x86_64_linux:      "c8290a41b28b8e46a3d75a8960c27c8046bc1fed5e23ea5dbc279ba7512478bf"
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
