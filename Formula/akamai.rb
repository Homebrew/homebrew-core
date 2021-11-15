class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.3.0.tar.gz"
  sha256 "338d4be3e5878d52c764bb2e2e5faf5ecaf0510a37c582b3644615df39718141"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "b54282d66fcf309cbb19dfea87ce87e6cf1756960bbdaf824987f2c638f2f598"
    sha256 cellar: :any_skip_relocation, big_sur:      "ae02bff8cd5f22c2d8c083950de16addf0f008c98bdd104aee2ef4d41fbbb0e6"
    sha256 cellar: :any_skip_relocation, catalina:     "c9873ba7c5c27baa7c9783ce964c5c62d97151c4bd4873d11fae343728d9a245"
    sha256 cellar: :any_skip_relocation, mojave:       "2287e1ca300d155e500392f5628aa8ad953006b1c263caa35c03e4d9591053a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6f587975677c2fc32993c6c4fda1689cff38107fa24b4cdbfee84c7c562ede7f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "Purge", pipe_output("#{bin}/akamai install --force purge", "n")
  end
end
