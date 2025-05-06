class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/codesnap-rs/codesnap"
  url "https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "f610782ab5acf36f626fce855a08ca925dd019a95d2dac5f7f7719983221c81e"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaae5dc2277cabce5724d55b6c0d115a1893962abaaf5c3536d6d83a695bddb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2584ad189be6ac5429b90c06ec91f346e7273154c372924ef04060f4ecce8ed8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf7ca506c720bcc07c81e2167c30e0361a2e6a4ee43cc375afd099605182bbb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbfeb98f7ab03b17efd8c1aead4c19e69bd4be40c97909122bd952ed728b3730"
    sha256 cellar: :any_skip_relocation, ventura:       "cda67c6659be3910f803e1030a170aa2a868bb6dd31f6b3adeb68b766a73b1b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97b8ed09c62719d62bb81b487fa3090c48c1dfcc0fbabb3710fc99dba578a5a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af6649a1933093f489051d8ad2a925372c60a7e1abdad0c62c66869c636e0695"
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
