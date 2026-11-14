class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.161.tar.gz"
  sha256 "87d6954541e25fdbe56dce3328d497e6b397108f11ad0f1979818f4bd8a44201"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f3c9f2e88311c0febe28f189ef20494345f238c5a404162db9b3dea98194904"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ffc4f1182f81cb4d0490cece3e58eb3b7c62b27fd15d14562310fea19516868"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10d23ca2d560aef06b430f8a41c0e2cc7e0acc8f2e594ff46f64833040089364"
    sha256 cellar: :any,                 arm64_linux:       "387c5e01ad751ab2ae7a9227734d083cd0f84dc6a09028e69800e0d7b921d21b"
    sha256 cellar: :any,                 x86_64_linux:      "0fb7726024fd3b69583d6f312cab7a507e6b0c4ebe93eaa3b1c82cdfbc993aec"
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
