class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "88b25f7d44cab6c964f2aac03bd266577a0355a51ad69788f7b709c1bd145f0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "cc8ef6a5777d028e6b478a5c27a92fa203f6a3f1de0912d2770f8de7671df239"
    sha256 cellar: :any_skip_relocation, big_sur:      "2a7fac5947fec9ed49ee8b2cbc3d70b6f80adc106c6d66d2a5921ea18f155c15"
    sha256 cellar: :any_skip_relocation, catalina:     "909dde4413ebf4f4232cf1b384cfc2135b9829cc384048eda44bd4afb0a38129"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d119c09c03c9c041ee91aff4b7ede4ce651935dcdaab7d49ed8394fc7c74f75b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "Purge", pipe_output("#{bin}/akamai install --force purge", "n")
  end
end
