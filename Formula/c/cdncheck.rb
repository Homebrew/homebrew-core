class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.43.tar.gz"
  sha256 "90aaa240df1ecc08300f0a73651f1b8830ba0ca95bb2ca2ec802bb83751409aa"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cb4f4e8688ac0f242bcc74faf3dbdd669d83371a7858411b327c589f140ea6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b008ffe91ccf63d31bac87f51d9fa1d7d21af9f42f20c7cd1832be064ca93b49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20cdba6f95ff84bb32b64cf767ab4b3103f0579b9d8e8641d158b926007fb6b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f25ab88679d87d776e01804a48490ec271f825ec4f3b7a895832e92f3c4fef32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "422ad2b209c988e4abc420dc9834bbac6423f701eba8074edc02bf3173a3432f"
    sha256 cellar: :any,                 x86_64_linux:  "4bc8e413122068f3b0fa61cca6da42039bd543f5b3194a1f10085a031348bed2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
