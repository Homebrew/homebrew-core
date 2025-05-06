class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/refs/tags/v0.8.24.tar.gz"
  sha256 "1886c5ef32882ed3389bbd15226f1bb9d0c3c411eebefdaef0c3941ae1c2bcf9"
  license "MIT"
  head "https://github.com/barnybug/cli53.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cbf53595fb96420c262541ac11ef60f88a90cb965b86a08d698759879f31f12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cbf53595fb96420c262541ac11ef60f88a90cb965b86a08d698759879f31f12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cbf53595fb96420c262541ac11ef60f88a90cb965b86a08d698759879f31f12"
    sha256 cellar: :any_skip_relocation, sonoma:        "29505b49a794c9b121fdca56bc0d4f823d4ed6b334e9463be158eaed1fb72f75"
    sha256 cellar: :any_skip_relocation, ventura:       "29505b49a794c9b121fdca56bc0d4f823d4ed6b334e9463be158eaed1fb72f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f680ca15bb30e5a668529f526d6242ee392a7e3fa5601624d7cc9816d95f4e8f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
