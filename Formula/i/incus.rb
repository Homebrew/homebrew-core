class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.6.tar.xz"
  sha256 "72cde6f30ff7e9764f6f24a2d11fb49593b06ce2b64f6fd032ce3d1fdcad1f28"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78a6b4a33e7e71f5a50dcec683d657af989bda1b3014774d12cf03c9fdb310d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c78a6b4a33e7e71f5a50dcec683d657af989bda1b3014774d12cf03c9fdb310d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c78a6b4a33e7e71f5a50dcec683d657af989bda1b3014774d12cf03c9fdb310d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d1e1b64bea28bf4983f9c7a24439f7351c7d15101adfb87cc45ee1fe54a2bc1"
    sha256 cellar: :any_skip_relocation, ventura:       "2d1e1b64bea28bf4983f9c7a24439f7351c7d15101adfb87cc45ee1fe54a2bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c674d06c5e1d830ea7b20792df267e95f972b0e4c0024d2815518b9ed4c0a630"
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
