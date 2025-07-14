class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https://github.com/thevxn/dish"
  url "https://github.com/thevxn/dish/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "3dc5d0b2eadd71b5290d26f1494be10b4ceab65314ded90508f210403a6b8ac1"
  license "MIT"
  head "https://github.com/thevxn/dish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9d261b1c2e9600bd1246717af651561009b99808c81930ab365e758c24e4949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9d261b1c2e9600bd1246717af651561009b99808c81930ab365e758c24e4949"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9d261b1c2e9600bd1246717af651561009b99808c81930ab365e758c24e4949"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea82028a78f0a6993840b23cc01adabf0d3b0f3699599f8c9a336abdc7197c7a"
    sha256 cellar: :any_skip_relocation, ventura:       "ea82028a78f0a6993840b23cc01adabf0d3b0f3699599f8c9a336abdc7197c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "723330b43d5bfc58210ebd63ecf13ee5c75a26fae040afb7999efbb9c000b2d0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dish"
  end

  test do
    ouput = shell_output("#{bin}/dish https://example.com/:instance 2>&1", 3)
    assert_match "error loading socket list: failed to fetch sockets from remote source", ouput
  end
end
