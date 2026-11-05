class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/6.5.0.tar.gz"
  sha256 "ed59c3b8d404e689100d757d9e0e4e86f14a5a4eb5710a807f70fd5dde39ca40"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6cda45c53edb205be7e8c1ec07d702277856d102f07624a4d75ade8303f17023"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dba4827918eb7011ce6af969562ab446c9a79f2bb929f8c2a799a93756f7de86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7e8e96344dc4185b90ea7414bdd3256fd095a2bbc9e70731411d8e1e0a44e15"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "90a47f6c338fbe7dba99be33108b68180ff6a1ecea0fd0fb5703aab56c6a378e"
    sha256 cellar: :any,                 x86_64_linux:      "c6c00030591d714fee8e4a64f98f97dfcd66bf31b06ce4d9712b3adc6a8d80ee"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
