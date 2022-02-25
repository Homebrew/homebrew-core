class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https://github.com/ayoisaiah/f2"
  url "https://github.com/ayoisaiah/f2/archive/v1.8.0.tar.gz"
  sha256 "11b127b0631ff6db979d7f8c59a6a59cc725e072489abbf676d2557ea6475dab"
  license "MIT"
  head "https://github.com/ayoisaiah/f2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b675674c09aa6c6922bcc2c3fec2ca0d56cb2842091b3210ac6e94fb0363e9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af42f08006c442d62b1db1e604dfc5c3e1906086f65902b8f069d51e5edced6f"
    sha256 cellar: :any_skip_relocation, monterey:       "365170c4d4cd8994a2110db618df37f70c6b684c71fbb6857961b420d041ca10"
    sha256 cellar: :any_skip_relocation, big_sur:        "3849c35a21e22d529b109a63c1fdbd89257016e09cff433ad39a79394dacfd34"
    sha256 cellar: :any_skip_relocation, catalina:       "cf6d3ca529060c841f6f06634770fa2657efb97e2604ea06bb4a136d5c4cc2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffb45d637be8c319e3936c2afb6f47efc35540ec5ac5f7bfc1cb27515f24826e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd..."
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin/"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_predicate testpath/"test1-foo.bar", :exist?
    assert_predicate testpath/"test2-foo.bar", :exist?
    refute_predicate testpath/"test1-foo.foo", :exist?
    refute_predicate testpath/"test2-foo.foo", :exist?
  end
end
