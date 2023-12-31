class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "595a52dc28bc6fa2892708c700584a26e2a3c08d46f0de8d1b35fbfa4f1292d5"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92d859acae9c893348a16d154c633647bd066416bc1f4632e4dfa7fc03efed3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e701b019ac3fc647d5ce7cf641ae305d863e3db80643c8a07a3fb46a1eb47c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4b8606484ea16cea03ee02e3fe2fc5bdbc4b6bdd0da7b64e0003a7743583f81"
    sha256 cellar: :any_skip_relocation, sonoma:         "de056bc14ef8aaaabc7d23548d08c9108071393d6018caec35cb83c5a7221bd2"
    sha256 cellar: :any_skip_relocation, ventura:        "29dab67c444ee74340496095c489701cbe5688dc2432e62f4662c757117d6ec4"
    sha256 cellar: :any_skip_relocation, monterey:       "9b130d06aa50892fbeaba2ec0bfbd7c88bfb4dd5376c21bf46b4a3c41b31bc17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da8ad941d9d9cb88a5c5b277d7e917678b289cbd43de4e810a44f274e2e9ac6f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
