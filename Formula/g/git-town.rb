class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v16.4.1.tar.gz"
  sha256 "5028be7dbdc42283deda25dbb6b6d1ff114581e081b38d30802ed4e8bd37cf42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91d593f88f73b113f1737e9823d0ca9725f68df055cdc0e42eb6d2388ea2a7fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d593f88f73b113f1737e9823d0ca9725f68df055cdc0e42eb6d2388ea2a7fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91d593f88f73b113f1737e9823d0ca9725f68df055cdc0e42eb6d2388ea2a7fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1a4a16756562d12eaacbb702481c9ecda405de3064ae13d87f17e21697f3678"
    sha256 cellar: :any_skip_relocation, ventura:       "f1a4a16756562d12eaacbb702481c9ecda405de3064ae13d87f17e21697f3678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "890e60eeb66248f7579d32f27be4b7623314ed9e66d72398235a7591c0dd823b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
