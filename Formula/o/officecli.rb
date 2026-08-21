class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.144.tar.gz"
  sha256 "58077ce6d719ef13ef24641cdf49e84c0123f48bad9625562b04f25c493c888d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d23567a796da16ef3a232a93d3216eaf16bd93224f02027c0e9552a37dba2a5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b237743d0218b6c88868e143e66b2640e0f16b38d823cacf52f411eb7a2dcd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27dc078da705965fd905e5868a3d91d332dd51b9ca1b99876401f18e85129e62"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad9dd78560197c537c2436095e8c9709b42fccd1e14f10751376ca89563f1b5"
    sha256 cellar: :any,                 arm64_linux:   "7ac70c671e13ac0844657ffbff9dc7652f8cfc2c0edd197836410129ec2baee3"
    sha256 cellar: :any,                 x86_64_linux:  "8b8a7ae350ee3bfb24fa0ee6c29425dedd3d18d1f112e329ee01f174f9cdac26"
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
