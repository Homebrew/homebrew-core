class Globstar < Formula
  desc "Static analysis toolkit for writing and running code checkers"
  homepage "https://globstar.dev"
  url "https://github.com/DeepSourceCorp/globstar/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "a98edec5423394924288382650177549e4997647d145fafa8ade03c687cb39a0"
  license "MIT"
  head "https://github.com/DeepSourceCorp/globstar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ba72c642f021e3bd727a487cee4410a86055019c9efb0b8c010c68f723165ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04bf11ea096ebbeb71a68dc7e566e7349de08e8ecc6b52371f143d2ffd770d1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af7b9c5ccd795ac8c0e469c7590572af67d6209e5b7abb02beeac079fb3bfd3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb3eb03ebabbda1c0cb05151a2826ed1251bddd180dc61ba01fd9a1b13589eef"
    sha256 cellar: :any_skip_relocation, sonoma:        "997d61fe0a81bb3b10c7ce36499ce54e8c15b07c83ec04162f34d11899eeb551"
    sha256 cellar: :any_skip_relocation, ventura:       "4aba6ab2960d1094c1589a50709706d91d1353beaea8e1a6dbcbc54ae6e2daee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8e25ef07cfe4dedf814d9580009b44875b715f5ea61a06410809ddeeb4c5318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a70f87f82041dc137573423d33bd685e47cf37f18da8c969208c9eabd7ad62cd"
  end

  depends_on "go" => :build

  def install
    system "make", "generate-registry"
    system "go", "build", *std_go_args(ldflags: "-s -w -X globstar.dev/pkg/cli.version=#{version}"), "./cmd/globstar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/globstar --version")

    output = shell_output("#{bin}/globstar check 2>&1")
    assert_match "Checker directory .globstar does not exist", output
  end
end
