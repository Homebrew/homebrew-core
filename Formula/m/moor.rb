class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "53baeffdd83c6f0c09f0b1754395fd7ed222df885dc4a758517a4d2ecfe62b93"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1435f939332b9793284ac13e30574b8fcabd87a586cd16b87fea229098ef4ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1435f939332b9793284ac13e30574b8fcabd87a586cd16b87fea229098ef4ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1435f939332b9793284ac13e30574b8fcabd87a586cd16b87fea229098ef4ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3f893dc6cb267b14f1d6220fb843ce8c8c57770d79825f6893eff110e22943e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b49d7931664a474a6b60c19108ef7fcffe3636d0421e06b6b7799aa3a7b174c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b84d6fab2a4093ceb973d50111e1ac039f4b87017a0b02be8f88af385c61f9"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end
