class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.42.tar.gz"
  sha256 "cbdee87045b3ea623036a698d5a38a11f11e3e73e192ab8bfd7a8f1b8269c5f7"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49a9843dba97e21b760b2df36d52f3283ad00a201f71ec724f73304464046621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49a9843dba97e21b760b2df36d52f3283ad00a201f71ec724f73304464046621"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49a9843dba97e21b760b2df36d52f3283ad00a201f71ec724f73304464046621"
    sha256 cellar: :any_skip_relocation, sonoma:        "a80615017e8e9e06d5ca575e63b1d8b1529727c322034d7f13b6bbeb8d9c0aac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a78023d4d1d3e15d55501dd1818cab0b2c75c18f9372090d91baea0e2d5a10f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67b8d8e2ae02380a9d60a2d4b1ef77ecd1c4be79753f7b5070978c439d613a42"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
      -X main.gitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"

    generate_completions_from_executable(bin/"fence", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    # General functionality cannot be tested in CI due to sandboxing,
    # but we can test that config import works.
    (testpath/".claude/settings.json").write <<~JSON
      {}
    JSON
    system bin/"fence", "import", "--claude", "-o", testpath/".fence.json"
    assert_path_exists testpath/".fence.json"
  end
end
