class ForgejoCli < Formula
  desc "CLI tool for interacting with Forgejo"
  homepage "https://codeberg.org/forgejo-contrib/forgejo-cli"
  url "https://codeberg.org/forgejo-contrib/forgejo-cli/archive/v0.4.0.tar.gz"
  sha256 "3dd84c58c8c5d5fc22b8456d9a4f35323e0386547743c6b24295a3dbc6a56fb7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://codeberg.org/forgejo-contrib/forgejo-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8b5b53ff8d02650413d9d7f0a1f559f067ab4a945589db3a4b730b8bc2aa2be7"
    sha256 cellar: :any,                 arm64_sequoia: "05a18d04827ced6895ff7b11b892377f8248a942f82bd11928eaa235b53c4a03"
    sha256 cellar: :any,                 arm64_sonoma:  "ab96cf3b9a63b36a7f13cbd08e470161aca51b63568d763c928426a621b4be94"
    sha256 cellar: :any,                 sonoma:        "09b267b22ce29b5b25bd82109ddf1a3fde47cadfd99f569e7c21708ea1b94eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da4205613b733fa87b70043da4974af792b759809c28a25b45a9e58cc1272859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b9f6aba4821577e529e68eb61a9460021edeb5fa54d7dfaf6f37ab42815fd6e"
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
