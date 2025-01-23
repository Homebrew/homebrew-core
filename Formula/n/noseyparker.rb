class Noseyparker < Formula
  desc "Finds secrets and sensitive information in textual data and Git history"
  homepage "https://github.com/praetorian-inc/noseyparker"
  url "https://github.com/praetorian-inc/noseyparker/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "c1b5947692a4b5c4acdba5ece024b2058f4b5aff663305462da79188ba78fca5"
  license "Apache-2.0"
  head "https://github.com/praetorian-inc/noseyparker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91a270bf1c1c12196a6ceebc33cc1a782371523b178fb76af732293711181209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef5a5e79fbe59d67cdf035c36ab2322401b4cb2c6483542e0f37475ff260f731"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f360b189b52b264c3f7a4d122c55cbde055c5fb9004aab13351a8f7eea87ede"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dfbb42df2f3c3c5b0f50238f968aeb3b42572bdeaf26dd0b456ce7516bbc711"
    sha256 cellar: :any_skip_relocation, ventura:       "62afe8bd58c73b2fc04d36a54b4e9a1336cbc2e32ded6a90e638bdc7531ce31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6de46a91fc4c6353a2114697c7eb290352d8ba9063bdf7a8872c0222783dfe39"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", "--features", "release", *std_cargo_args(path: "crates/noseyparker-cli")
    mv bin/"noseyparker-cli", bin/"noseyparker"

    generate_completions_from_executable(bin/"noseyparker", "generate", "shell-completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noseyparker -V")

    output = shell_output(bin/"noseyparker scan --git-url https://github.com/homebrew/.github")
    assert_match "0/0 new matches", output
  end
end
