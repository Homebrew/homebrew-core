class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.132.tar.gz"
  sha256 "228df67ed5fdb5fdbeee0ba83b9766fc54d97b1b158c51c0e59813412687e112"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db366452e027c22e13de28333c81e67091793956200f84330d3f49e01a230330"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf08e336940216bba6119833c4a00e3c0e72facf533da8a4579cd72ab87a3fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c78b5f80fd8a581dda3546e578ea1eced3619ae8dfac831b5b13304c849c769"
    sha256 cellar: :any_skip_relocation, sonoma:        "e810fb99b51884c9076fd49c2c784a6a61d09b7b9d71796bba36941d76233786"
    sha256 cellar: :any,                 arm64_linux:   "698ea442258bb64cc59881a90dc2df62848a9d738eced0deb13d56ce75968c45"
    sha256 cellar: :any,                 x86_64_linux:  "cfab153a56e776ffb85ee5b9cc8184b219d4897bd16dabe12339aa45ed3b8989"
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
