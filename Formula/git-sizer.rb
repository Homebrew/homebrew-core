class GitSizer < Formula
  desc "Compute various size metrics for a Git repository"
  homepage "https://github.com/github/git-sizer"
  url "https://github.com/github/git-sizer/archive/v1.4.0.tar.gz"
  sha256 "5dafc4014d6bfae40e678d72c0a67a29cd9ac7b38a0894fc75ab8c05a9064a4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ecca715be890da74fc5c54dd791a0709cd3b643e074a83f8661acc393e141b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "7314b14cbb15ac4b1a2c627326fce43df7faf26c03a69c59b98ab5f4f1a51bce"
    sha256 cellar: :any_skip_relocation, catalina:      "f3d288c0482c3929c890569c44ef8238abed3bd4160cac5a6f149839ac8ca1db"
    sha256 cellar: :any_skip_relocation, mojave:        "e775a308318106d27bf454ad1b16562506925ec360fc966346dd8ddb9688866a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a292c841a2ce459ce25299e684a54d7660e29ec290b6d1c4238e426385ebcaa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.ReleaseVersion=#{version}")
  end

  test do
    system "git", "init"
    output = shell_output("#{bin}/git-sizer")
    assert_match "No problems above the current threshold were found", output
  end
end
