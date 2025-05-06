class GitWho < Formula
  desc "Git blame for file trees"
  homepage "https://github.com/sinclairtarget/git-who"
  url "https://github.com/sinclairtarget/git-who/archive/refs/tags/v0.7.tar.gz"
  sha256 "457a31f9421053cec30c26305badc9288f1645f0ca46829e00c3b3574297ee59"
  license "MIT"
  head "https://github.com/sinclairtarget/git-who.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2573864e506810bb5cdf009de69ffec294ed93b19d9ae98dc71d88a88d32de8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2573864e506810bb5cdf009de69ffec294ed93b19d9ae98dc71d88a88d32de8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2573864e506810bb5cdf009de69ffec294ed93b19d9ae98dc71d88a88d32de8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "de40e9aab5e4e48c42cbf2edd7f1ad5c1562396757bf6a229e52ada3bf20b5a8"
    sha256 cellar: :any_skip_relocation, ventura:       "de40e9aab5e4e48c42cbf2edd7f1ad5c1562396757bf6a229e52ada3bf20b5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cc8bcd7b086f6cc7fa8873c9bf3af24a78fa0911a0dcf68eb9bc0be43f858d3"
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
