class Dstp < Formula
  desc "Run common networking tests against your site"
  homepage "https://github.com/ycd/dstp"
  url "https://github.com/ycd/dstp/archive/refs/tags/v0.4.23.tar.gz"
  sha256 "1ab45012204cd68129fd05723dd768ea4a9ce08e2f6c2fa6468c2c88ab65c877"
  license "MIT"
  head "https://github.com/ycd/dstp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d846454cb98d9ca168c8a2975a2d551a00b444afa2a3a0599d4bc956e24c9b35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d846454cb98d9ca168c8a2975a2d551a00b444afa2a3a0599d4bc956e24c9b35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d846454cb98d9ca168c8a2975a2d551a00b444afa2a3a0599d4bc956e24c9b35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d846454cb98d9ca168c8a2975a2d551a00b444afa2a3a0599d4bc956e24c9b35"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb67648c382f56115631967b9d5c7fc76c9209299e524ea22f7d32c48e44f34c"
    sha256 cellar: :any_skip_relocation, ventura:       "cb67648c382f56115631967b9d5c7fc76c9209299e524ea22f7d32c48e44f34c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f66f81e0d40aacd8eee14bbc3d74ce73cbebe5da3f36958e5c2d1f90d1d23a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bbbb70466510b3a9d41a5a6479b9a667d7d55deaf87e739a0957201995ded19"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dstp"
  end

  test do
    assert_match "HTTPS: got 200 OK", shell_output("#{bin}/dstp example.com --dns 1.1.1.1")
  end
end
