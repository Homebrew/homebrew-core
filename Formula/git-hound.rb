class GitHound < Formula
  desc "Git plugin that prevents sensitive data from being committed"
  homepage "https://github.com/ezekg/git-hound"
  url "https://github.com/ezekg/git-hound/archive/0.6.2.tar.gz"
  sha256 "acfafd618fc1c1d748b23a4e3d1f89cb46b8f2d5e81aaa30f07fe0b0e4cd0bff"
  license "MIT"

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    houndpath = buildpath/"src/github.com/ezekg/git-hound"
    houndpath.install buildpath.children

    cd houndpath do
      system "glide", "install"
      system "go", "build", "-o", "git-hound", "-ldflags", "-X main.version=#{version}"
      bin.install "git-hound"
      prefix.install_metafiles
    end
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
