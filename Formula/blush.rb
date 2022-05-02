class Blush < Formula
  desc "Grep with colours"
  homepage "https://github.com/arsham/blush"
  url "https://github.com/arsham/blush/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6db6b033bb5d4c4ac350b36b82d79447d5b91509db3a5eceb72ecb9484495e54"
  license "MIT"
  head "https://github.com/arsham/blush.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    test_file = testpath/"test.txt"
    test_file.write "first second third"
    expected = ": \e[38;5;196mfirst\e[0m \e[38;5;46msecond\e[0m third"
    assert_equal expected, shell_output("#{bin}/blush -r first -g second #{test_file}")
  end
end
