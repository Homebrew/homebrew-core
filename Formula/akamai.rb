class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "338d4be3e5878d52c764bb2e2e5faf5ecaf0510a37c582b3644615df39718141"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "842b169770e4426d42f8b5263d6f9b0dea954f9f02a682c66faeae73f30646c2"
    sha256 cellar: :any_skip_relocation, catalina:     "6ec819f683c492b61fb18fad43515d7ce85c4c00d80bcc6ff3b2cc6ef098bf3f"
    sha256 cellar: :any_skip_relocation, mojave:       "9a34412f05ecbbae48a65983548495cd0ebc5ad234f358163f714accfd44091a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "273809b294a7cd451de7aac6a324e548105a97697677ef201590274998044ff4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "Purge", pipe_output("#{bin}/akamai install --force purge", "n")
  end
end
