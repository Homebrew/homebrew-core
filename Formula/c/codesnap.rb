class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/codesnap-rs/codesnap"
  url "https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.10.8.tar.gz"
  sha256 "b5acb52f9c4d395d815ce61bccb835ee87e971ad72192c070e8ed565ae8fcb98"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b09d3bd4a671218042913bb02555f3578cb64bee42a55736e4a6dcc43095375f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "921db28ce4daab49dc2b6a1e2f07f9b3f3b51434405bcb5466caeb2a4e4e63c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b19d545c22aabf9d5c0fb7687a6b2347374f8971e449d5b44f372575c0e83f7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "36a50cfbe2bae59b0d7089527901198a205b5f8430f2755dfbb11efc2c3555cc"
    sha256 cellar: :any_skip_relocation, ventura:       "4b995c68c32eb71757396aa31eb5e32e2fa687b1f618fa8f0dce79c876b57364"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50459fa62d06a29db4985327eec166c9483b57a70c59b2208e0e80037b436dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79b02ad6007e103662aada6a0c09af6576ab22248e6887440e2d1449455320a1"
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
