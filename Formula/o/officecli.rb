class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.162.tar.gz"
  sha256 "99e6ae2fa573d990fd7515147befc8ed758642024d68ae1f3503de7773e05177"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a71faaf1445a793d7f9946564904c1f3eb9f4c7182171f5a0e525b9a1821d8e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cdaaad8692e5a9372a1d7f147e4a29e924dd2272d82f45fbc2bd9c5cc5ec4522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bec8a7b8b0189ab58d1ce98f492497eb0bc46b55c1ce8ffb4b4c802ae2a217c"
    sha256 cellar: :any,                 arm64_linux:       "4a56f00de659fece152309bf545227b233178892af889d4ad91a523bf46fe4dc"
    sha256 cellar: :any,                 x86_64_linux:      "6d94c34ba98ff2ffe4145a88b23f08ef5f3fd29377b7e5f71c62f452a6ccb172"
  end

  depends_on "dotnet@10"

  def install
    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which build containers may lack
    ENV["XDG_RUNTIME_DIR"] = buildpath

    dotnet = Formula["dotnet@10"]
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
