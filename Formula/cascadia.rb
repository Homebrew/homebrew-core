class Cascadia < Formula
  desc "Go cascadia package command-line CSS selector"
  homepage "https://github.com/suntong/cascadia"
  url "https://github.com/suntong/cascadia/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "eb7f88f23f176e74d1aeb3b34efeb7763de8ad5445566bc92ed9fee33e9cebd1"
  license "MIT"
  head "https://github.com/suntong/cascadia.git", branch: "master"

  depends_on "go" => :build

  def install
    # go mod init/tidy are needed until https://github.com/suntong/cascadia/issues/13 is fixed
    system "go", "mod", "init", "github.com/suntong/cascadia"
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/cascadia --help")
  end
end
