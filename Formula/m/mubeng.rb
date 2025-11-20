class Mubeng < Formula
  desc "Incredibly fast proxy checker & IP rotator with ease"
  homepage "https://github.com/mubeng/mubeng"
  url "https://github.com/mubeng/mubeng/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "57a4e10f25ec5e70fafc97cb21a13ffffdc63d3b8004055318ea0ecd1ab63507"
  license "Apache-2.0"
  head "https://github.com/mubeng/mubeng.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "180f314d468ebc17cecabecfc0986cead05b47c09c614d1211781fd55dbff0ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d861eb83c6ac431a6dd5f3b4ac21886702859ecc595c273c0fcf3648fd6c9601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d861eb83c6ac431a6dd5f3b4ac21886702859ecc595c273c0fcf3648fd6c9601"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d861eb83c6ac431a6dd5f3b4ac21886702859ecc595c273c0fcf3648fd6c9601"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4c4a171a1183c4a5f2786dfd43c60e1f7d1974b1ac8c4ec7e49b71cf99da9c4"
    sha256 cellar: :any_skip_relocation, ventura:       "f4c4a171a1183c4a5f2786dfd43c60e1f7d1974b1ac8c4ec7e49b71cf99da9c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce56204c6fe76e17b551d782c71ba39ca92cdc003f841fbcf2d84c8298cf45fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a67076731b843403953aa84c40487ff346fe6699833f46dfa07f6f95a6e515d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mubeng/mubeng/common.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    expected = OS.mac? ? "no proxy file provided" : "has no valid proxy URLs"
    assert_match expected, shell_output("#{bin}/mubeng 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/mubeng --version", 1)
  end
end
