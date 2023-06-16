class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "0adcce4f7e4910f10a52a74bfca283e0e3e15a6d5d762b7c6af7df32158f600c"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fda1666a120f04542597bc349b526d1067f5cfbd3c5a791beb5f2fdb62a3139"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39e42009a2606c1f7597e2edc07141a11e5e85bb9e46cda97fe6bd6e2521cc1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7698e53de12b760275bc803395240220a253a3b3230173b40e24f059b727e706"
    sha256 cellar: :any_skip_relocation, ventura:        "246b4901ba023058b61b0c9d7f9cd4c78fc30c1e5c543c9422638ff2de0864d2"
    sha256 cellar: :any_skip_relocation, monterey:       "0f889dc5c73b024a691834c2a674374cc5d6568c10a0d74b0960ad3fd58d7bc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "712022b4c45f44ea28f109b3e845b9529bfb777205065fc86f2232fa86f6d8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "186b5f0d986ca9d9c55352cf2fe226110ce97957a43f7fe202dd5039859586c7"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "GoFrame CLI Tool v#{version}, https://goframe.org", output
    assert_match "GoFrame Version: cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
