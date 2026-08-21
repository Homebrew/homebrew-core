class Errcheck < Formula
  desc "Finds silently ignored errors in Go code"
  homepage "https://github.com/kisielk/errcheck"
  url "https://github.com/kisielk/errcheck/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "d16b7757bf57dea5bbcfce42badd1bbfadd4c112b2da90b4ccaeb81c6c438c1e"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87ab2f4d507e4f352e7b0caf8c609db8a7120f6565703025f4675a9efba64a06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87ab2f4d507e4f352e7b0caf8c609db8a7120f6565703025f4675a9efba64a06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ab2f4d507e4f352e7b0caf8c609db8a7120f6565703025f4675a9efba64a06"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb8c570bd1db614a45e41f2ba0757c1526c1bbdb5b93e20dd59bb025fb3d8d8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "091cf764499995cdd32d70e493820116f9eb64838fe7e536036037c594a5b508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84f2e8121e858ffa87725fda4a35d4d55e88221ceae431e628e7d334c0a83fa1"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args
    pkgshare.install "testdata"
  end

  test do
    system "go", "mod", "init", "brewtest"
    cp_r pkgshare/"testdata/.", testpath
    output = shell_output("#{bin}/errcheck ./...", 1)
    assert_match "main.go:", output
  end
end
