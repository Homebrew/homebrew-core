class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.140.tar.gz"
  sha256 "c72dea4efb69251a0e35b6572cc5f9c1183e7fc33499d0ae01cee36b0b5ea03c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "520a538f7cf9cc907091e1d45e2cc0f7bcfd715e30b5aefe7cee3ba71a1e2a65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "307d2722c94d7f147eb5b008c7309fa2eeb86923adcebd7dc55d282d8c719509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf01f679429d21a400567271ccf13efc0808b6412145380f744fd0f734c6fc7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e514cdc37461317012d30ed0463e9225163a49d1d10f94695985da2b61c524d3"
    sha256 cellar: :any,                 arm64_linux:   "15a0505eb6d1a59546429e17e01ce32ff9a3d52d84d89782ad5369289d327371"
    sha256 cellar: :any,                 x86_64_linux:  "3de3ee5ca25e451fef54350682ee83920bd1e9f5b5659e373a626ee765362eec"
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
