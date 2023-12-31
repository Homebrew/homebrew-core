class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "c537d1b14d6aeffa83561d154494c5d27252e54006ad78386c5347e173fb79cf"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc309bdc13d8d1bbfcd18f422565e88a3287979588d17f22bf513663454fd996"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deaeff1b420e76775993fbb02efc664eaa23621f2045a644c1d10381fcdce154"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "550303bddc9c78b80e2f6f2bea10e1ea6f90910de1bca910029325b1006dd225"
    sha256 cellar: :any_skip_relocation, sonoma:         "b14ef15c6d57f26b0501efff2dc860d3c6c43ce7748a505d3a417c3390ce54b7"
    sha256 cellar: :any_skip_relocation, ventura:        "3c69fafc3683064e7db6a65b960326a22129b85c7063fdc6a3baca2ed5453e6d"
    sha256 cellar: :any_skip_relocation, monterey:       "ea47ac65f02e20f707b4c308801ec80df802ba1719212855046a85aef129c7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebb6aff2521d2f54d0624d21154a55a15c1601d72d00f34df96e85ba7316ae4f"
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
