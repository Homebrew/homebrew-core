class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "5cd4f7309c216a2895d512603d6a9742ed2cddfd69ecc77837c9d2058f44fdf8"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dccdaf0dd457379f0ef66f7d0e712a130277035d880cd549d41d6c7d5d73730e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dccdaf0dd457379f0ef66f7d0e712a130277035d880cd549d41d6c7d5d73730e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dccdaf0dd457379f0ef66f7d0e712a130277035d880cd549d41d6c7d5d73730e"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e709cc660cad821a4f1ce18b6f2e21cc62193b9d95190972cbd861c207b687"
    sha256 cellar: :any_skip_relocation, ventura:       "83e709cc660cad821a4f1ce18b6f2e21cc62193b9d95190972cbd861c207b687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4913e1c42d64924e23c2516cac47b662671a5750d345fa1d38b4913f2e98df9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
