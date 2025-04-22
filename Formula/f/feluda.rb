class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/1.5.3.tar.gz"
  sha256 "851d673150219667c5fac86b70be62d283af05d294aee0d511a65874232c8ba8"
  license "MIT"
  head "https://github.com/anistark/feluda.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "496e8c45eef964b0c6b4f368c37b248a08e23e1881e333ee59c2d43d0c5d9d26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf0436fb12b433a1a98ae81cf649b0a90a2191f86f12bf63565486e45fb15597"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a112495a27ab84dfe7e41bfc410654da68dd267e59b22140fd7c77533097fd3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6fcec68b4694579855097b3b374d9705039abaf0abcca8b144dda02db9beb2e"
    sha256 cellar: :any_skip_relocation, ventura:       "86d159f264a3199f9eb8a62268c6b270312be20a9c528cb6904491a78109c3e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ba6fef0834bcd92b13736cfe340ef973022f566277e862a8d0e07ad8860cfc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f755c857f20be919bc24c57f3ed7b5b34f750587f58f61f3cac2114a65a18498"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match " All dependencies passed the license check!", output
  end
end
