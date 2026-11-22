class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/7.1.0.tar.gz"
  sha256 "153c34dbb99f850da0a13525cb1c32cd1e8604020acc4f5aab8560bc13ded27e"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7bc78b7b9860c0291c818e26a780a2a21b5fa69f710e17d8f1381dc1c6dc4f19"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b820c898905781954d9be08d752843d3c9dbae169ed0f36e0530b50604050e58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ac9131f8b47d501686c8b2707f817ff9a218e6b47c56ab2ea82c273f6ea04c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eac19739dd2a33b17fee8cdb8bb6d0267da349a6fe89ec18729310ff6e630360"
    sha256 cellar: :any,                 x86_64_linux:      "3853b3acd7beed39300680b4fff5a61ffb828e75e30ed3d672c9a016843af82f"
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
