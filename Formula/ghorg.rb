class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "4dcfca1e68ae577e9acf90f4e2f904d6f4997c49a25ac53b056b57b33dd15c7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c36d5f9b360ae87c4d666813ca4a971014dfd066726740b51f4c24ea9ac568a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c36d5f9b360ae87c4d666813ca4a971014dfd066726740b51f4c24ea9ac568a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c36d5f9b360ae87c4d666813ca4a971014dfd066726740b51f4c24ea9ac568a9"
    sha256 cellar: :any_skip_relocation, ventura:        "2cb2eb14d13a13113c415f0477f20b48e773ec0cbc8b4725fe54fd26d33a14d6"
    sha256 cellar: :any_skip_relocation, monterey:       "2cb2eb14d13a13113c415f0477f20b48e773ec0cbc8b4725fe54fd26d33a14d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cb2eb14d13a13113c415f0477f20b48e773ec0cbc8b4725fe54fd26d33a14d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24414c2246a3b8d0aa556de7fb389f3048bb4dddfc91383182f471f93fd9a3ab"
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
