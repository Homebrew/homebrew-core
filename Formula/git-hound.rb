class GitHound < Formula
  desc "Git plugin that prevents sensitive data from being committed"
  homepage "https://github.com/ezekg/git-hound"
  url "https://github.com/ezekg/git-hound/archive/1.0.0.tar.gz"
  sha256 "32f79f470c790db068a23fd68e9763b3bedc84309a281b4c99b941d4f33f5763"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af1391d6c19eb3b2aa550fc169c4015d3b9302577f699d26e01a8def2d1bc196"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee385550d377c33a0daf08fc38454c782d849c72a73e6dd257123d047437711c"
    sha256 cellar: :any_skip_relocation, monterey:       "f443b7b00338cda50f23d0fa64b3e6db5a7d57c5a5e685e1b5f1e222b0a0cca7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4431bf04ab9f0e93b9da932b71c4c53be423d73c1a20e5321fdcd6a4f5b0bd85"
    sha256 cellar: :any_skip_relocation, catalina:       "b800dc830647b0806200364a0b242c64cef639618a5ccc9268f3333f3a645802"
    sha256 cellar: :any_skip_relocation, mojave:         "6bfbbe48552eaa75d5fd861c1feb9bd21a5d47c1718f4295ce469062965311de"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5951f740815c5e38e8d0a97270bf867f99cb0a2ea2ec9ee3cc4b4ccba5ee96fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f27441dca7619968e685c5b91221d251872376412332fea4d318a17d4c283c4c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-hound -v")

    (testpath/".githound.yml").write <<~EOS
      warn:
        - '(?i)user(name)?\W*[:=,]\W*.+$'
      fail:
        - '(?i)pass(word)?\W*[:=,]\W*.+$'
      skip:
        - 'skip-test.txt'
    EOS

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
