class Noseyparker < Formula
  desc "Finds secrets and sensitive information in textual data and Git history"
  homepage "https://github.com/praetorian-inc/noseyparker"
  url "https://github.com/praetorian-inc/noseyparker/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "4de92335bdf68eaa8378b1f232b7082943cefc850df0bd2519d9d281247f1a5f"
  license "Apache-2.0"
  head "https://github.com/praetorian-inc/noseyparker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ce37940acdde39b749116c996dd7593423b7c702c05a3dcb69c3d69715d123c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb57f1fce63e93ff03a5bcdf688d4097d69a526021889d747ead2bc0233bc3f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e29c106856a44d68686292217771f114fb9975f0cd13c0aa6f22003dc63baf29"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd07b2fbb4a8652eb3209a98e69860166bf0966e1eb279c993472b272dfdc596"
    sha256 cellar: :any_skip_relocation, ventura:       "9a9f02b384542990d19d29d9f4ab0a86dabdd02da032caaa100c0b099f554dc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96c637d35682a70aeb0d4b4bdb6c0b79b738b3240a0857688cd5e061e1ec9d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43d9f57dbf2601ff3c088caf989bc9338a2dc6ef1aac096582cc4d98919c4438"
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
