class ForgejoCli < Formula
  desc "CLI tool for interacting with Forgejo"
  homepage "https://codeberg.org/forgejo-contrib/forgejo-cli"
  url "https://codeberg.org/forgejo-contrib/forgejo-cli/archive/v0.5.0.tar.gz"
  sha256 "028ebcbd744301fbfd144cd9bc5ff0a27e02d99b02c8abafb20742299715c556"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://codeberg.org/forgejo-contrib/forgejo-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da03e5e9283bacfecb9085684ba35701932a95254486a5d25b841f898715bcc5"
    sha256 cellar: :any,                 arm64_sequoia: "50ef4d22fdd29d0144769db602da1a46098c6649959f702c7193a6ce55a474af"
    sha256 cellar: :any,                 arm64_sonoma:  "b1d585c8520c57d6cb8a2309e3ea1ca71cdc278e371b3ed35d58645b1ea6af54"
    sha256 cellar: :any,                 sonoma:        "90fdf8e55f03114a11c912f20ea1eeb60c09f26a69628ce94c6e1a5d9066076b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dee5a25bc9af4873f25cadd9152a7b43a7fe9f281694cc617d9b7c5a181ee4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bd9495f4637a8392608b9dfb0cb76c9b1e4a6fac326e5ef29008ee232d1f218"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fj", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fj version")

    assert_match "Beyond coding. We forge.", shell_output("#{bin}/fj repo view codeberg.org/forgejo/forgejo")
  end
end
