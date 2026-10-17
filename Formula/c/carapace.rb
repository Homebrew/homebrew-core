class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "1dc7314cbda4643186bcf00b6e2402002a113b09a0220e5d564a40e77daa886e"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a3ffbd3e21125b777ee8e0839bccabb2fce6cab8f22be15de20606a29819aa4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a3ffbd3e21125b777ee8e0839bccabb2fce6cab8f22be15de20606a29819aa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a3ffbd3e21125b777ee8e0839bccabb2fce6cab8f22be15de20606a29819aa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b96fd6e5b85bad3511b5536c6d47337c9eb14ba3f71c902820525e2249eb733f"
    sha256 cellar: :any,                 x86_64_linux:      "ff706e616e05b66ad26ac1b92865faec8c7b3529bdcb05daa24927b1c046f23f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "generate", "./..."
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
