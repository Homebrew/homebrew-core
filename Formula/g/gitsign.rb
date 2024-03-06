class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "4bb66ace71ec560a50ead6157db69950c3e9e9960c54f8f10037530de9d4e93b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c0f2482a268ca03f6dd96db998ee1206d7d80a8d6ab20732ad1a404a361c83a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7014ebd6b189aa2704103fe9f0a5ad9f9f2ad9af674f4c3755ccfec25f8ae4cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd10d50fde1362f754f543ff35f8e32fc18364674940c72b12b9cbcc0e0ced5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "488696f08371f9a9ff126134781df5c9ce44746db7c2b4d58963f99caa56785b"
    sha256 cellar: :any_skip_relocation, ventura:        "71973db5e6e0eba68a34a52cafa7b46227ea55e9c9e2f1b3c20b37ac7cc61a29"
    sha256 cellar: :any_skip_relocation, monterey:       "41b9d4eb9115f295b331f00bb32b93ed147f6348cce7f8286ec8aca87037739f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f8fbadad12de8e3217d064e8df19a2e504b8f6a3c937b3947535a7848c9cf37"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gitsign", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign --version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end
