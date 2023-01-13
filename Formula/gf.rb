class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "d8eeab143703a9f98d0b5ea00d09873394db14d979510b836ad191e0b8e3a026"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7aeebc0363785d2859db37c0faf3746f930c5c9800acc2e50f289c153d6216f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "852385e1e1c6eb0a7b78cbdb8b5f6f0506027031196f540a22a7e58234627382"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4aaac8597bedff8e8e37359848cfa984a2bad4dd22cbfd246a251c77e6bd57ef"
    sha256 cellar: :any_skip_relocation, ventura:        "02bd4d956f7e6bcc928eedf762ff8b415e7d7464b68f084b5e3773ed874a17f9"
    sha256 cellar: :any_skip_relocation, monterey:       "f58137c52e75ed730caf4865a601d831267657dc3b882ffd87d4dc153fa94e80"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d41680d9363b8d5be1683cb75f2985ab6a19b740723ac2b1ec66c5fed2e36ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7305e80e4fcc7f7523ca3d96daf69bc8fc75a16ae88b4e21e4bb2db01403fa8c"
  end

  depends_on "go" => :build

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
