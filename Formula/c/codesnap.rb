class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/codesnap-rs/codesnap"
  url "https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "bf3f040866fbc4b71f9b5722ad01f6e2de29a9c81f0d7ceff03966fa5cab2966"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f9c9133207fd0d42e052eb39ed2ae6233072059e2b76269b92b11dba952301d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e5553ad441d9f56869cbb96cf97b917c41f4a8ccd2be341bd9f979ee6757bfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "509f116d12bf9e5930bedc1fa065c8854c00d20ed20bb0aa387c727b9c872197"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e6315058dff2960028217cb2c5bb12b08cf4eb4f368d9a900b5689b86a15ecd"
    sha256 cellar: :any_skip_relocation, ventura:       "317a767e978aa123e873c3f06ffcd58364acd90d0fb477c5286f84f2a81f3693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c1928b60e6c278fd8aafcdaf3956ae52cd32af2b47fa5d2927600d08c1a893d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc6325d90f73e297cd0c92453a4c8c95ec276ab877885fd8214bfeecbccbd676"
  end

  depends_on "rust" => :build

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
