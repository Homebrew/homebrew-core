class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v1.0.0.tar.gz"
  sha256 "4e8b9d33fd57e68e2f3e94f69572945ae2860e4eaf25a72fd6d72b8580dce8ba"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33c182f354778a74b131f76ddaa9a30cc978277a63c4361e2c038769f060a9e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ce052bf1ae54ea1e9901e94e7244e3bc7866eb5345065dde966cd27e53a0c93"
    sha256 cellar: :any_skip_relocation, monterey:       "5602ea351bf3eb0444e1f4023ae8d0f65742ab639c430bb50ba7e8a9fe664f65"
    sha256 cellar: :any_skip_relocation, big_sur:        "f753d52849c40a9472bdab294afbf1f2cacac3edde521d6adf6e3751299e4921"
    sha256 cellar: :any_skip_relocation, catalina:       "5265e14c07f0f7ccb5c901b999cc5216e419697607a52b29fd071b1192a9a111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ac1c1f9a535f55fcde6735f95aa1b46f36e9240d515b358de8e1dce9e53dc5d"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build", *std_go_args(output: bin/"lean", ldflags: "-s -w -X main.pkgType=#{build_from}"), "./lean"

    bin.install_symlink "lean" => "tds"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Invalid access token.", shell_output("#{bin}/lean login --region us-w1 --token foobar 2>&1", 1)
  end
end
