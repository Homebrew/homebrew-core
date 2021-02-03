class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.13.8.tar.gz"
  sha256 "a9b599b1bcb190e75c294cc96fe8b476c88dae06f3aad046a388e0c15ab8e149"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4425e73ae549f35c5ce84958bac7e01bc9c72933136e19963031f51d794bc9eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "16acbd1ead0286f88a36c9a46ba49aae66135fa6004ffad46dabce6c14c44762"
    sha256 cellar: :any_skip_relocation, catalina:      "4dd6e5c25ee27086b81c242d0a8075bacd00a01fbb5d5e9fe0a80bf48df9c5ea"
    sha256 cellar: :any_skip_relocation, mojave:        "6c751d70becce09380e40a50a1ff8fd3d8bd4ab1433bce9d58a628d16cf971c5"
  end

  depends_on "go" => :build

  # remove in next release
  patch do
    url "https://github.com/chenrui333/cloudflare-go/commit/5c74c62.patch?full_index=1"
    sha256 "428c3504205af52b90a4d16e07ba7069e71ac2546787f9b6218ccb4784975b09"
  end

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid format for Authorization header", shell_output("#{bin}/flarectl u i", 1)
  end
end
