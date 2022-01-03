class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "32fed7988c1f786aee8a82318a4d042d8385ebd35537db7c586e05282c8308cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff6c4506e9bb709aa2ba5446745e48d7aae70ef9d29cc327eea7e1f0023ebf2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff6c4506e9bb709aa2ba5446745e48d7aae70ef9d29cc327eea7e1f0023ebf2b"
    sha256 cellar: :any_skip_relocation, monterey:       "c1474c86508e2a95b8e1697cce372a5b5b5860185eb6f4c92cd0f89a4af97014"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1474c86508e2a95b8e1697cce372a5b5b5860185eb6f4c92cd0f89a4af97014"
    sha256 cellar: :any_skip_relocation, catalina:       "c1474c86508e2a95b8e1697cce372a5b5b5860185eb6f4c92cd0f89a4af97014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "998a7c5349c971ac2c4255d7a348b76b282a45ce57aae467783345c54b246b43"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
