class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v7.1.0.tar.gz"
  sha256 "061472b3e8b589fb42233f0b48798d00cf9dee203bd39502bd294e6b050bc6c2"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9c6a22a4969f64b659735ebe853a838283c48315badb0fb0257a37e05163620"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9c6a22a4969f64b659735ebe853a838283c48315badb0fb0257a37e05163620"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9c6a22a4969f64b659735ebe853a838283c48315badb0fb0257a37e05163620"
    sha256 cellar: :any_skip_relocation, sonoma:         "52ec35aa9125f17fcd2b266fdd9a8bf73de77ab266bff10c517451256a3f9507"
    sha256 cellar: :any_skip_relocation, ventura:        "52ec35aa9125f17fcd2b266fdd9a8bf73de77ab266bff10c517451256a3f9507"
    sha256 cellar: :any_skip_relocation, monterey:       "52ec35aa9125f17fcd2b266fdd9a8bf73de77ab266bff10c517451256a3f9507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa22386774d9b6290553c6e788dcfc5a1421f345b017dbb9b2294276f5570d36"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
