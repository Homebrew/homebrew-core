class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://github.com/ignite/cli"
  url "https://github.com/ignite/cli/archive/refs/tags/v28.3.0.tar.gz"
  sha256 "00ea4ca9fbd04af84cd1e88861a8759618afdc03113010688b1e1e3b0f9d6578"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38e62034b26c18f70a6c4e06b22b6b35a0346c0422d76bdc59fa1a5b746c0d89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eac26ec65373c5958776259afd3ba3ba54fd5a4858b85f517439e6118696a93c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e0f399b15a4dd3be122a9527b348dfb091e1bbfba8ff943e3edcb84519ea9f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a01b4767a2228229f0226460371b591e1c61bd8c585e6d710806e8918b8a067b"
    sha256 cellar: :any_skip_relocation, ventura:        "74237890f7e735f203f1f847dad8053fde07a3b23c6ac340f0d99c1f2f72d933"
    sha256 cellar: :any_skip_relocation, monterey:       "2a61165bbd36e80432899f822f972ecea6f210a6b5d81409084c1384da8136cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944017cea20f77c011540c1ff853e5b76f9306635bfbd586bcba045e784e602c"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    assert_predicate testpath/"mars/go.mod", :exist?
  end
end
