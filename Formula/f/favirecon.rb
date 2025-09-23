class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://github.com/edoardottt/favirecon"
  url "https://github.com/edoardottt/favirecon/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "72d8c7b8584322f5e82a140abc46c95ae3b86580353f7e79a395e2351b8293f1"
  license "MIT"
  head "https://github.com/edoardottt/favirecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78ef3cfd54fa6fd77ceece4382eec6297cb905d6ae8a161f1a3dcca471675a6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebc4ff865a852564480d49a059d2ec8b4fbbac34e72c6af365557f2a6bd16a9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebc4ff865a852564480d49a059d2ec8b4fbbac34e72c6af365557f2a6bd16a9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebc4ff865a852564480d49a059d2ec8b4fbbac34e72c6af365557f2a6bd16a9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "514f536af4919aedbdeed9facdfb99092371d498680871e09fb19a21b4aa94cc"
    sha256 cellar: :any_skip_relocation, ventura:       "514f536af4919aedbdeed9facdfb99092371d498680871e09fb19a21b4aa94cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f47ca49a30aef22ce88fe13109b5aa79e3be9ff68387f3d66b28fc02253afa5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/favirecon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/favirecon --help")

    output = shell_output("#{bin}/favirecon -u https://www.github.com -verbose 2>&1")
    assert_match "Checking favicon for https://www.github.com/favicon.ico", output
  end
end
