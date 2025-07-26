class Nyan < Formula
  desc "Colorizing `cat` command with syntax highlighting"
  homepage "https://github.com/toshimaru/nyan"
  url "https://github.com/toshimaru/nyan.git",
      tag:      "v1.2.0",
      revision: "e586ac49a07ae7e0d30dd9d805a314ebf2231ff6"
  license "MIT"
  head "https://github.com/toshimaru/nyan.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/toshimaru/nyan/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nyan -v 2>&1")
    (testpath/"test.txt").write "nyan is a colourful cat."
    assert_match "nyan is a colourful cat.", shell_output("#{bin}/nyan test.txt")
  end
end
