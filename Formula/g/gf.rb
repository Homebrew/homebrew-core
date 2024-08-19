class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "1620df4e094a049edec788cd917bb8d117a6ec97800ce814eadddad30ef25245"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72fb8440a261055bd3dd35df8c6b632cd983568795d2d1f984659aa3379c03e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdbaa5e5af7b19a06bdcc1c461ccd3508506fe198a72f35d75e90c447679cf25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a41656d2b27f2997ba1eff82e0f875e00b785734b747d464e56b30d30213a4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9b52cfdf059d18498ccd20e31385d6b58a114598b9747becc91c6fdf061d23a"
    sha256 cellar: :any_skip_relocation, ventura:        "474e3392351c00edbdd6f72390095963e89b9b40f7bcb9cc16a59e77a026f7fd"
    sha256 cellar: :any_skip_relocation, monterey:       "2f3837a9b9f20641ed0f6d891a80ba283fd6e6bcbad505dea59e4f7ea2a5640a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08330727ddd399ece20db43cd576410e397c4c12ae19775faa3db9a10de135b9"
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
