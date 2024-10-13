class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.7.4.tar.gz"
  sha256 "cf2072b33fae489864b79e69b506b78cdf88c40769cde937d0822a086fd05103"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5a512f6d4254ba6a5ccef9aaba80f0cbcc78395532b20655ffc8df746ff826f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a512f6d4254ba6a5ccef9aaba80f0cbcc78395532b20655ffc8df746ff826f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5a512f6d4254ba6a5ccef9aaba80f0cbcc78395532b20655ffc8df746ff826f"
    sha256 cellar: :any_skip_relocation, sonoma:        "edb4d25fecf0021169dc113c835ff868e743dff184f903841c6bc9ead0efb7bd"
    sha256 cellar: :any_skip_relocation, ventura:       "edb4d25fecf0021169dc113c835ff868e743dff184f903841c6bc9ead0efb7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27b95547cc3d63d9ea8f6a50725df0cfcb6a0f650d5127ff51542a0f185e4954"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
