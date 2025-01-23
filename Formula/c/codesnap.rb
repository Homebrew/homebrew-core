class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/mistricky/CodeSnap"
  url "https://github.com/mistricky/CodeSnap/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "acb3e160039c9986f4566f3504df2c820558e62b7a412d4fd5030008f2c44f81"
  license "MIT"
  head "https://github.com/mistricky/CodeSnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87e46adb2b04171b28b5dfc78ae05f78f148044de5dce1467d511153247d8cee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b33ed994518151e27221f8210aa7890f108e107d56956d362dd18626ab8689c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc2e8dbe3ee5187e3fe56ce60b6a5160bbcb7764079e46cf1643aa7206471215"
    sha256 cellar: :any_skip_relocation, sonoma:        "0137a524ad3dcaeb41279a7d8116dde25740eccf78a54b7bc71e42ef31f01c51"
    sha256 cellar: :any_skip_relocation, ventura:       "12e63b80ef9724e9cde857eea9a2d671a3540ee4339d6881e94afe5b5dcbf12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14f94426bba298fd9f0e9cce02ee56c3cf5a271182328cb73f68403d6c93588b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
