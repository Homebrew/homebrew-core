class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.6.0.tar.gz"
  sha256 "a10a6fc40d87572c6d3f3becdb1a289269e17526d038749f2fa04dd9f591f26a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "396965ab785d39bc07d52eb6004f4113d77aa4513d34573e613f03b87567f260"
    sha256 cellar: :any_skip_relocation, big_sur:       "05223b193daf8184ac8b19cfcdf65d411da5e52cc1004eab3508093745cf4daf"
    sha256 cellar: :any_skip_relocation, catalina:      "9aca18af854ca4b09bb8ff1486edc4d15351e86dbf28ec68bf804e486fd02e5f"
    sha256 cellar: :any_skip_relocation, mojave:        "a6516737c1785ec78160ff1db163dd8a3b459d05b5a536fff762639b6148195d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"dlv", "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
