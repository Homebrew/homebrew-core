class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.241.0.tar.gz"
  sha256 "3bf31157a13d6b62cac6867e59ab5f762ad95a60c0c3957ecb9dcf3820438f5d"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00bc49bde51ecc834a3e20f90644b1538d4fd695423611602a8012c4938da247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee7b3d608f465be46c2abaa3c52aa111272db6e1f9575c68b0bc26ae4fdf3625"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f68bbeaac64e2d7b9681b18fc0bdab2c88fb6011c87c424b05e5e24e4f641048"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3222a624b9a57c1b4bd298ae2276293b4819c7592751cabe79be6aa78d4e1c7"
    sha256 cellar: :any_skip_relocation, ventura:       "13d46468ca32b19034371133dbaba4b5a9347e247177a86b952a24d4b080d594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a743c7ef4e8f84d8440f5b885baa449a9db7820f960a8ae88917ea92db66164c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
