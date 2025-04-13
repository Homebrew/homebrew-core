class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "ea86ea01c5e0e11a96876c82adb64d4cd7554b0074426203db923e0bcf033242"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "447dc075e488d91ecd8dfd9cbecac67172d85a757679c51cbad0d245dcb2a620"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "447dc075e488d91ecd8dfd9cbecac67172d85a757679c51cbad0d245dcb2a620"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "447dc075e488d91ecd8dfd9cbecac67172d85a757679c51cbad0d245dcb2a620"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca218d30792368d6d19fe46a9eb05846a91cffa6bf14ae1c3c887ca99d3cbf24"
    sha256 cellar: :any_skip_relocation, ventura:       "ca218d30792368d6d19fe46a9eb05846a91cffa6bf14ae1c3c887ca99d3cbf24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e628ba588f73e2cf30275465908a2e98d5082e6c715e4ed1b3b799bd49a71dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7518d555ea9a5842b6c7114a0d01417ba35fd468ba5ba91f223e8cbe922f3d7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
