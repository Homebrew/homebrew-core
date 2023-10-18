class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.2.10.tar.gz"
  sha256 "ea3d76abdbc458b22efc2a5bfc294ddc17fe7a329936c054f1f292b0c87d455f"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "634cbfffc90ecdf346adb2073a406a8798350f80add22782ee8e2502f0eb8275"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbe61bde5349a0404bc61ba530cde90dc6f6a80b8f476fd2a91875362e2a3e88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46ee3c89ada3e1f48117487808c361441ea484a4b7f044595902fe4003513c1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c780414f4e9020ee4da8d246f56fa941d248a0dac0afcffaaac4a45e6d831306"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9d69c9e347b91a0dc213dd9bee4d6b8d6054224f21677fa06d2b756abba80f0"
    sha256 cellar: :any_skip_relocation, ventura:        "e493742c9a95c9fb94aff947dc2fd96dbb7199d5d70973304bdd70f747f467bc"
    sha256 cellar: :any_skip_relocation, monterey:       "aa30214d6b436954db636d31c7821b22dc34d5267a9781d0f2b7edb5123e7477"
    sha256 cellar: :any_skip_relocation, big_sur:        "20f96c67357d9550d96959594cdeb788a576e2785e75d26e3308390a0df81dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30cc6592e7c74fca94340f53206a3e33d9dcd97c117c86761d77a321945872f1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
