class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.7.3.tar.gz"
  sha256 "b1ccfb7996670c1f176c96cb66877168c24a17a0da04d92f9d4a5fdfbaad48ae"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13cd9f25dc3e4b8bd24648c412d325cd14db1d46f2237b38ab1599fcb9b0c95d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13cd9f25dc3e4b8bd24648c412d325cd14db1d46f2237b38ab1599fcb9b0c95d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13cd9f25dc3e4b8bd24648c412d325cd14db1d46f2237b38ab1599fcb9b0c95d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d9ce5a3186d1a72bb23d6ddd603916107c7f1dad108bbc8861dc273a3b9ed9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d64c6803ef37d889dad903121d7667894dd55a6c5470d8bf7cc7a503e6460fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff2f62831890b8be28a7ae8e481f86689b505bf2bd853606e92ae867d7301f61"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
