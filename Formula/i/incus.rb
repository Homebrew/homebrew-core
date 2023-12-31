class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-0.4.tar.xz"
  sha256 "bee802ade967402b14401e1b5ecbd1336b007a4d816bd86644abbb43b9fc1845"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e28575929962251e3ce98b105d64eb8d02a18ebcd0166fca612230e51495b65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92b4cf94af094f124c645c8049dbf51bd8499ec5b2dc36f5b9380ae760e6cb51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36181bc5093d6d13c6e7b59405acd7766d485b7f6d82e1f9dd3d4d016f6a653e"
    sha256 cellar: :any_skip_relocation, sonoma:         "81ca8a462aa4b9296fc796cfe533b404f3a9d5200d4c1d24590bb11ee7f69cf5"
    sha256 cellar: :any_skip_relocation, ventura:        "200d5a24a0a5cba43feabafab27ed7c20c61a3eab73fd8aa954fa99af5bc16fc"
    sha256 cellar: :any_skip_relocation, monterey:       "0cddb87037d66f3dc0b242dfda27284849f6a968151c66c091698630ae66d494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5134a7fb168e57433a068d0e6539ba70018d6b3060710fd66074631b3ee2e1d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
