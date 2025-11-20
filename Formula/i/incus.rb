class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.18.tar.xz"
  sha256 "c9bac9a357493b3d330818c059c657468351ba3495ef89ce53ad18ce81cf3044"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24e73004f8d1989a4922ae97500d5f795517b0ed5e6af5278ecfd9cd6bc191c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24e73004f8d1989a4922ae97500d5f795517b0ed5e6af5278ecfd9cd6bc191c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24e73004f8d1989a4922ae97500d5f795517b0ed5e6af5278ecfd9cd6bc191c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "049859d5f9a0197bd99b57d2814a3f54d60e08fe15be96069e0324a8b51016f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa53bf0442c2c68d5c33431e4630a827477123f7f8f92b6e5133ccededeba8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a3456e7e752512905e1777e4e59e2f959303d676566ef7680591a97197ca930"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
