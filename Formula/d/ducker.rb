class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "b906599f268fcba965e7e8fa4d5a768369faf520e19207f7e3f8a4987193b588"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcb82169c67866c9290968d5ac2c819f16f1eb3e0a862a70962c47a1902a734d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "893abb45f03ffbc39ffa7c8607d0cbd3ba43a4255401c4380e60aab3d8fb6c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f603023abe54db15ed2d8f6026fb027683626ec0a3009b09566d47f8cb462434"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e9962ab855557de1f5f9dd4f95e2ec39d926a79f6d5171f038a27c8b739c750"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90e5eab9cb6c80c080367507df345bd81d52c333fc0ece1bae0ff21619ed33fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa7707d0e1248ddc055620bb8f94891dda1d6b259202a8c51b37f7431a0dfbd2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
