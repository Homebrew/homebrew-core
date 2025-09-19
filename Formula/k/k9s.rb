class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.12",
      revision: "09c1c0795051f443da6b75a11705e25c0c1c7c6b"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da33840711421d4ff6be13340ef42ce207a45358b1f30b4edc1bd215612b7a48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af0d0bbdd0aea198fc393508b35d0c77ae3a9cc4e974ed95614dc80152822a40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bbb1bbcd84e59d8686850e1659510af7f5e61817bafd421a78577614d987eaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "3084079aaf777f0114e1a7aa2674e75838ce7b055eba982cdf47a78ed1d59f5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c2b43582c787c26d5747a4d8badc81ba187c91b3eb7ed39d37f44567a2f8b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26cef5d091ec3c37078fafdbcd5c210091946485110221de6e371fbbb989adbe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
