class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.6.0.tar.gz"
  sha256 "ce5eea62e9d130e3557c11016c306485ccd77919cf85d706a2556bce28d085ed"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/vektra/mockery.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "838bc4e94d6889dab090984c0f70062d5a6e65c25076eb891140e0caa80cb3b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "775e3c5ab4ff9baa1e464a3402cc5df4d40938f8e1830743e713e48dbefc6861"
    sha256 cellar: :any_skip_relocation, catalina:      "8b4d00f30efe40382d919e3deebbb89cedb178c9b7a26be8008105bd8b8ecb9d"
    sha256 cellar: :any_skip_relocation, mojave:        "95b2ea44dbbc182f2b870a3526fc41abd98b43dcb700d6a4b10f789229a17ed2"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=#{version}"
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=#{version}", output
  end
end
