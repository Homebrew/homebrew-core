class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "3fd24a09e1f67b9abbc8370711c0ff2a6f4180dc723a1ba848de798c0aea2274"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f71e8ce1665eca02073cf7f895c7e631cfc9630f5d0411c0a78e137e0a53b381"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f71e8ce1665eca02073cf7f895c7e631cfc9630f5d0411c0a78e137e0a53b381"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f71e8ce1665eca02073cf7f895c7e631cfc9630f5d0411c0a78e137e0a53b381"
    sha256 cellar: :any_skip_relocation, sonoma:        "be524b7470c746914c426b3d0392c7b2830c0813421154b5c915e81ee52ed147"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f65862b0df7a41c5237389a171c41cdb50217942066ef8ebec2b2e307d8479d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2008b43e93bf1e19a413e605f8d40229ae43b2ddea5b36be205623e5115a6cd"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
