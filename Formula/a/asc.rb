class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.3.0.tar.gz"
  sha256 "0a41ca93f48b96fc909022e370b403c146717a652f0090fc2cf97bfaab2cd275"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81111a9934813a191886482b007a1ee04f37053e512a8bd4ac9b8c531fa2807f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "362d7da4d65cfb66fb9921be8e28577f55fceaa836fdaa466f431230c72182df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "889412da1503be3ac0b46818a895708c8bfb033bb1dd999d883f4dee8795d694"
    sha256 cellar: :any_skip_relocation, sonoma:        "86afd52611eff7225c22771ddef06afa266536e350905ba36d43e68dc81cc93c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ffe8a379ca876366eb4215cc7c0686e8073814f6699b431a604ba8d174fe5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a978667716547165c6db61bcd5bd385a532d7df9fda91eb5f780cad6dbcde35"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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
