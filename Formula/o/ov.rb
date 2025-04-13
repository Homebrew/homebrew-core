class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "8f2c8f1246d6fd1affee3d9570a7a085c8c608d3a710829d5097fca0e53290a0"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49ebfa5ffcda9f737823f13c7a6af2d3100ef9e102ef92c30875f51f2b6400ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49ebfa5ffcda9f737823f13c7a6af2d3100ef9e102ef92c30875f51f2b6400ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49ebfa5ffcda9f737823f13c7a6af2d3100ef9e102ef92c30875f51f2b6400ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "837fda3a333c59cdf99cd0e4210b927f64dc1f411e334e66843d79e00ff97e8e"
    sha256 cellar: :any_skip_relocation, ventura:       "837fda3a333c59cdf99cd0e4210b927f64dc1f411e334e66843d79e00ff97e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8556ea12ceb992fe32c593ae596f7ccd522386df9d4719c9c2c61255e3bb5282"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
