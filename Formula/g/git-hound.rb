class GitHound < Formula
  desc "Git plugin that prevents sensitive data from being committed"
  homepage "https://github.com/ezekg/git-hound"
  url "https://github.com/ezekg/git-hound/archive/refs/tags/1.0.0.tar.gz"
  sha256 "32f79f470c790db068a23fd68e9763b3bedc84309a281b4c99b941d4f33f5763"
  license "MIT"
  head "https://github.com/ezekg/git-hound.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "15f176bb2320758e6a88797ee77011a189b7814857a0ed920dd4b32a3335012d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "373e91c48dda4ac71e85490387430dbfdb73d27d72a0964a33933e8e6d5f1753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "741af126dfc7d95d6d5b17efd48a36335e60fc1cf4847a5487e36a969739b2a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d2d41fc442a37b2902a182cb034a023bfcdb992fd27e7d668ddab3077bd07cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af1391d6c19eb3b2aa550fc169c4015d3b9302577f699d26e01a8def2d1bc196"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee385550d377c33a0daf08fc38454c782d849c72a73e6dd257123d047437711c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8313b4d62a2b0d21d21bc42812431573b07585c179cbbad7c2d5bd1fba20d88d"
    sha256 cellar: :any_skip_relocation, ventura:        "5958f86063b6163227599ba6fa622ff75e600698017d97f4222f0d5de5f9d41a"
    sha256 cellar: :any_skip_relocation, monterey:       "f443b7b00338cda50f23d0fa64b3e6db5a7d57c5a5e685e1b5f1e222b0a0cca7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4431bf04ab9f0e93b9da932b71c4c53be423d73c1a20e5321fdcd6a4f5b0bd85"
    sha256 cellar: :any_skip_relocation, catalina:       "b800dc830647b0806200364a0b242c64cef639618a5ccc9268f3333f3a645802"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b3f6b4750e32e5f6b3a11bd754c2b026261373e3e1b54256b6ae3e48dc3bc4a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f27441dca7619968e685c5b91221d251872376412332fea4d318a17d4c283c4c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-hound -v")

    (testpath/".githound.yml").write <<~YAML
      warn:
        - '(?i)user(name)?\W*[:=,]\W*.+$'
      fail:
        - '(?i)pass(word)?\W*[:=,]\W*.+$'
      skip:
        - 'skip-test.txt'
    YAML

    (testpath/"failure-test.txt").write <<~EOS
      password="hunter2"
    EOS

    (testpath/"warn-test.txt").write <<~EOS
      username="AzureDiamond"
    EOS

    (testpath/"skip-test.txt").write <<~EOS
      password="password123"
    EOS

    (testpath/"pass-test.txt").write <<~EOS
      foo="bar"
    EOS

    diff_cmd = "git diff /dev/null"

    assert_match "failure", shell_output("#{diff_cmd} #{testpath}/failure-test.txt | #{bin}/git-hound sniff", 1)
    assert_match "warning", shell_output("#{diff_cmd} #{testpath}/warn-test.txt | #{bin}/git-hound sniff")
    assert_match "", shell_output("#{diff_cmd} #{testpath}/skip-test.txt | #{bin}/git-hound sniff")
    assert_match "", shell_output("#{diff_cmd} #{testpath}/pass-test.txt | #{bin}/git-hound sniff")
  end
end
