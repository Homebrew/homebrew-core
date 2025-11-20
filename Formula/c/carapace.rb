class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "c5f4576be4b0964213255562dda7d3b692d5654394b17e16ffad0f644e006a6f"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc89cb8622ee7a134a9091ef6e4e3e309be1cc6b9327c7c3980ac47f8c56ed4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc89cb8622ee7a134a9091ef6e4e3e309be1cc6b9327c7c3980ac47f8c56ed4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc89cb8622ee7a134a9091ef6e4e3e309be1cc6b9327c7c3980ac47f8c56ed4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1855cf6677c90b881b0132d2e9f59da697732d17597077d8e9b7bd05985a6c2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21b4e2c70b2384b26aa57b8c42f65fafb9f7b19b4357115aeb20647854f38ccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a20b19cbe4ca7831f195d1e91ba700edc5f9aa5c732353348fd2de44e17f4745"
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
