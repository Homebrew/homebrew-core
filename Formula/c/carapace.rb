class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3c3ccfc8212ec74dc90885b1f029a955508aa942e446367bda8cd3b3d65ae8fd"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d93d4450d53a2b5b4b45fb9f836040326d7d7c4d1ec3652c6634cc416a5bc284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d93d4450d53a2b5b4b45fb9f836040326d7d7c4d1ec3652c6634cc416a5bc284"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d93d4450d53a2b5b4b45fb9f836040326d7d7c4d1ec3652c6634cc416a5bc284"
    sha256 cellar: :any_skip_relocation, sonoma:        "d74a0fecbc1466a9ea760a11557aadea948e218e4344ab167e8d4cc33275864b"
    sha256 cellar: :any_skip_relocation, ventura:       "d74a0fecbc1466a9ea760a11557aadea948e218e4344ab167e8d4cc33275864b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b7f67f9a595bd2efcac13e3a63c36d8ebd8ff81ba27aa44e3a0785b04838a79"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "-tags", "release", "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "_carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
