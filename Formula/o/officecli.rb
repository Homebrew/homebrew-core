class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.163.tar.gz"
  sha256 "740ceebf57b6476129afb001f5c962e1321416ab5f395eed62ef63d2963de3f7"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "9866a771cb477338732065e4b7f614d879b7e37de6983c914a065651132b4d74"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "250f33e3ae994dfdd12f01f93be553006a3131e4fefcdec452babd3925768bb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8dca8af165e4fa34b5f57de839603cc4a881e059e9df757bdd574a98b7c3e37d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "960a9a66cffab89d883d1e939a0b8200888227908ed816383de08a259f610382"
    sha256 cellar: :any,                 arm64_linux:       "a50dfb40abb4cdd3244bb54102d4292b6b9e548601b2ec07ecbd0790a1801c2d"
    sha256 cellar: :any,                 x86_64_linux:      "1d7df8e32fe240e3b94b22400e8f4e3028c15f774e7c53ea31f3bcf8fc284a85"
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
