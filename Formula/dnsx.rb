class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.0.3.tar.gz"
  sha256 "ccd47a2e6cc5ee3081773fc0fe45d9a0270f079a4c980ac9c6697dd6163b1740"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47bdf35382eae8ff57668d10cfff9b9bc385b03ec8e945fc82bb1113518a2c1a"
    sha256 cellar: :any_skip_relocation, big_sur:       "7590a203a15703313b3e6d6b57108a994cb3293157b789ff38ac36bd99d0a7ce"
    sha256 cellar: :any_skip_relocation, catalina:      "8e7f6f5530ddb2f399f2d2ed3c5765a5246cdea1460d96533a349d4257fc40f3"
    sha256 cellar: :any_skip_relocation, mojave:        "c9dcba9a117a204a47a88c6e8abf7f241ac9647eeb12f5a35c93042c756cd2a2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
