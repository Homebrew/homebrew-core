class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.5.tar.gz"
  sha256 "d368c47bbfc055010f118efb2962987475418737e901f7782d2a966d1dc80296"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5b20c6f5b4114292d86fd9f78596863eca617bc27a756547f3863957bf760ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5b20c6f5b4114292d86fd9f78596863eca617bc27a756547f3863957bf760ec"
    sha256 cellar: :any_skip_relocation, monterey:       "5f5b652e976e178c143a0a0c98194d624881d4d756d83f0f966834edbfbcfa8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f5b652e976e178c143a0a0c98194d624881d4d756d83f0f966834edbfbcfa8c"
    sha256 cellar: :any_skip_relocation, catalina:       "5f5b652e976e178c143a0a0c98194d624881d4d756d83f0f966834edbfbcfa8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e446730f6b54b58dade1ee10deb6370d11324903c34156c5c0e2ab8f44d85d6e"
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
