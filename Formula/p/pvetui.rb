class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "6c5f6d5c8721c6b5a11349539c95af778300d347cab533bf9a6272d9461ca977"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b59196c5fb810a8c4d3881653e8d260bc4a94d8f42f9368b5e4fe97430126e25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b59196c5fb810a8c4d3881653e8d260bc4a94d8f42f9368b5e4fe97430126e25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b59196c5fb810a8c4d3881653e8d260bc4a94d8f42f9368b5e4fe97430126e25"
    sha256 cellar: :any_skip_relocation, sonoma:        "db54bfbf28b71c8eed6baebe16cbab29f6e3ba67a870b550263e8d428a591aa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f9903d2d53293e61ce4065dff154476103a69b8bb901e45bb513afc0957cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3d429b501243b01c854c99c8c92d094c2b58f7d71f9396597a2e81ddecb8fa7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match "It looks like this is your first time running pvetui.", pipe_output(bin/"pvetui", "n")
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end
