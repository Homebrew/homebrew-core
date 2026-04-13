class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "340c806f74fc19a2e9d0443f48239cc3dc40fa5c001355fb355a3f486dccf4f9"
  license "Apache-2.0"
  head "https://github.com/sigstore/gitsign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bacb71a978c2b7971220a61f2710d0ee57f242fa5d7c129ee5a8270bd57bd9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bacb71a978c2b7971220a61f2710d0ee57f242fa5d7c129ee5a8270bd57bd9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bacb71a978c2b7971220a61f2710d0ee57f242fa5d7c129ee5a8270bd57bd9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e9965bfdcd0667a982743cdd836f0ec059f1c9780fac6b75949f224bf308dc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bbddb53c8cfb0e35656cf3cff189e9d24e7862ecc77fcab61b9b1ab95c948c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19b45ca45444552cc4ae6ed18123f1af38b1a7791effe4f259d76890000bb727"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "go", "build", *std_go_args(ldflags:, output: bin/"gitsign-credential-cache"),
      "./cmd/gitsign-credential-cache"

    generate_completions_from_executable(bin/"gitsign", shell_parameter_format: :cobra)
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
