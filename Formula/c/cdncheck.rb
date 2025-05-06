class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.17.tar.gz"
  sha256 "87216de7e623a293d405a90d0769a014eeb169a64a471c2e117c07ac303b7fda"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d89d18dd3e2961adee82e6047392a200846d8663c2f1ac5807da1d52d4fd807d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f289a97f36b26a9e5ca0678391f3833c690c103855dde9bf6119e3d9650a094d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "753e51b7a35e63bf79e15c2357cca0048d7fb3f5ca29dec8e3d122486a239828"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3c9b2cda2aad799828030d9d039249286a48bd2e11c32a5984629174932a5c4"
    sha256 cellar: :any_skip_relocation, ventura:       "4159a1e6aa00d8e56bf0455c5c39f885ec52b15049d8b37a81380055f41b899c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a02a3048d6a23bb256c4d3fbe7c66d80793e6c0f367c94a1ea5dd3a9a98e15c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
