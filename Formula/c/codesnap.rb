class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/codesnap-rs/codesnap"
  url "https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "365d64b0a752396b55d400c08e287c1b09556a8eaca4242cab55d17da8a7af48"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b652969b9ad9931a999c2b3b78ac75371349949d491e8cd758838746b77c5cf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad11570c9eeddf4afcd9e67003988bedbe32a1505c21b7e1b11bc6d89ed0fb1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c02757f660660e4dc81828cd43c7821a037ab52bc9fa76853bd65bf97200390f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e581a5cebd9c81d98e0a278e60ebc72d2dd715fb26d503684466d7475e2937ee"
    sha256 cellar: :any_skip_relocation, ventura:       "8b2b06bd64aa3c300a1d59430e9f5900279644eb7332120b38601605c8c8aec2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a40df7b26e9e5ac668cf0305c804cc532136db044476ef7f6a365cc7def4b541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fad19ec118338d34b169bc4c3796fe50628792ae62979d57f1cd5d3a0fe0864"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
