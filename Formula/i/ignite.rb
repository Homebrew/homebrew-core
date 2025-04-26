class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://github.com/ignite/cli/archive/refs/tags/v28.10.0.tar.gz"
  sha256 "92fb98e8af121fefffd2e333c6affa27bfb209bcfab7fd744b5852748a96e812"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1cb8a0ecc1805f09980c52907e6f797b3dbafa1b45d22f33914d65a32149f16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66c6f7356f621f87d9c526a3676cbdc489dfc336b0c475fe417e7a5f22315226"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd2e9d9b1d8c659dc1d9f0830ee41a0efd5c4b1e5380a8eadd2c59c73db5c43e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc9c4f987bd94796563c7ead67a7a743703d6bbdf58f42dbfc4a4fc62a03e7ba"
    sha256 cellar: :any_skip_relocation, ventura:       "937380c6deabd83d481c55696a7bbc8cb64d31241c1b6481851e4c24d21768d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ff38a04ba6c4a08132bd9d460a159da9c431eac244f3ad6f7d08589f549c688"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    assert_path_exists testpath/"mars/go.mod"
  end
end
