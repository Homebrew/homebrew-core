class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/6.3.0.tar.gz"
  sha256 "23aae809bc5a86b8d69b8f53ca260b278fd2240b3f57484caea9323ba8d9e43f"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2bf661b6a4478d2dc4f88cfcd12687d1f9209e39e2c5394f5ca48737ae91be29"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "32fdbed5bbdd89377619a23dcb8be42e0cad0c9de00852e0494a03862b37e9de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0533a45644850087241b52f811c10681bd3a7585d784955b40bea849c21aedba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "599ca20d42b734a665c75f88fbbe43579f1a373a9dd5cdb270aecac7e7dd9f00"
    sha256 cellar: :any,                 x86_64_linux:      "4f9a67dc85b9ea7d88053971c1a29b6937852319f2b3bc0703a589616c4fe701"
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
