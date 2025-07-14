class GitWho < Formula
  desc "Git blame for file trees"
  homepage "https://github.com/sinclairtarget/git-who"
  url "https://github.com/sinclairtarget/git-who/archive/refs/tags/v1.1.tar.gz"
  sha256 "b88efe18a39987006df113e097a0e96493955237613997b56c940ff591473ea2"
  license "MIT"
  head "https://github.com/sinclairtarget/git-who.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1a53fb17a9a37e67ca3f9e59b2816c53ca34204c0779ed84a94aa27e1f5e10d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1a53fb17a9a37e67ca3f9e59b2816c53ca34204c0779ed84a94aa27e1f5e10d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1a53fb17a9a37e67ca3f9e59b2816c53ca34204c0779ed84a94aa27e1f5e10d"
    sha256 cellar: :any_skip_relocation, sonoma:        "738e5938dbf462fcf3d297d72a77ca47252fcfacc7202296fc78bc0987875364"
    sha256 cellar: :any_skip_relocation, ventura:       "738e5938dbf462fcf3d297d72a77ca47252fcfacc7202296fc78bc0987875364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d740e976ce6a927fafe9f33d361079510d3388307e61d85273f2d048932e321"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-who -version")

    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "git", "commit", "-m", "example"

    assert_match "example", shell_output("#{bin}/git-who tree")
  end
end
