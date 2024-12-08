class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.24.1",
      revision: "be051153525b018a46f71a2b2ed42cde39a1110c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9af9c2aa45688a2d2b9f996df37071ff55c02a0a6ebcbd5d224cb48fc82d294"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9af9c2aa45688a2d2b9f996df37071ff55c02a0a6ebcbd5d224cb48fc82d294"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9af9c2aa45688a2d2b9f996df37071ff55c02a0a6ebcbd5d224cb48fc82d294"
    sha256 cellar: :any_skip_relocation, sonoma:        "13100dee8f64b80f1f7f50c0361c9282f57ceb9590203f3c79e0dbbe2c6ec55d"
    sha256 cellar: :any_skip_relocation, ventura:       "13100dee8f64b80f1f7f50c0361c9282f57ceb9590203f3c79e0dbbe2c6ec55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b094dccce264cf7aa7deff733ee077b097c1000412b175d6185e1842fdca4bc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
