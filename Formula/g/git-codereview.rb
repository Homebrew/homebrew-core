class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "6590c869c7d0fcd749f68e28abccc841923a3a741e5869663d21f999ce0d8234"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "064dacdffe85c751d0cb4ade8e015cec5e9a7cd4c2b76291d3fff2e988af01b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82d607f2dd3a631e3c1ed76c5cce53da340885d6de05615ac5bfcf81925871a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b41ead56bd5eafcd33478854cec0721f25240baedf31931bf42474fb42443730"
    sha256 cellar: :any_skip_relocation, sonoma:         "a621314ec6332bdac2c997f6e64801040d62ceaff5b9a72599ab58e51dd75c26"
    sha256 cellar: :any_skip_relocation, ventura:        "511ce0a342c57787cf682796753a182b05b04bb686a5973e88150d1b07f7ee4f"
    sha256 cellar: :any_skip_relocation, monterey:       "341993b220c92b01f0b43fbfe83088199d85302bf07177b9803fd0dedfc9a57c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441c583fed82b0b15fcb8d70d1cbdef21af624266753054ff4721a7b3e65e10f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./git-codereview"
  end

  test do
    system "git", "init"
    system "git", "codereview", "hooks"
    assert_match "git-codereview hook-invoke", (testpath/".git/hooks/commit-msg").read
  end
end
