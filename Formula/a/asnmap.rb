class Asnmap < Formula
  desc "Quickly map organization network ranges using ASN information"
  homepage "https://github.com/projectdiscovery/asnmap"
  url "https://github.com/projectdiscovery/asnmap/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "66941d550238de9dc3b9486072acb2baf5f158c800bb3ab7c75d81f1b1df9df7"
  license "MIT"
  head "https://github.com/projectdiscovery/asnmap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74f6face763385abcd3e34b6cd80d09518c9ac32ff391f7acc0cc37b0d98dadc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "930050a225bf414ea4a1a623f043bb7c1837f33c5b17fce6ba50039a2ff11ec0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfb632e8c5a3081d4dcc168acde3017964878b67dd95c1bb7234679035e9e81f"
    sha256 cellar: :any_skip_relocation, ventura:        "6c264c751c1bfeeaaecea4821812ac7104df668696727897f93bd41495c5e803"
    sha256 cellar: :any_skip_relocation, monterey:       "4fd1ee8804310cbcb2f6a5cb63c0d5bebcc478c7b5a652f4748ad13c51dc4082"
    sha256 cellar: :any_skip_relocation, big_sur:        "af93a5b7997ae0cf976ed75f52e8213f400f92da312a03bf4f4f335c1ce349ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c85a0bd97acc0c31dbfd44410d8f66e79418bc2bf0e705f8a31396be7cb8b315"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/asnmap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asnmap -version 2>&1")
    assert_match "1.1.1.0/24", shell_output("#{bin}/asnmap -i 1.1.1.1")
  end
end
