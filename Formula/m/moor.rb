class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "4c2c77f9fba14e982be70e2cddbe7458b9bf7524655a0c059edcfd8348105b9a"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80d43104b9799e03f152de21ce236ababab808ecb974320486e2c400556a30a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80d43104b9799e03f152de21ce236ababab808ecb974320486e2c400556a30a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80d43104b9799e03f152de21ce236ababab808ecb974320486e2c400556a30a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "62f8e4b36479b86e3553fe2aaa0d6baa3cf43ed37f886f826ce1b404df90da08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98872c8ad897d4255992486fd1eadd4c40003603f7c6c2ad96a66acfa299994d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bab9a949644edbd3629a3bb7323f78a3675981c1058e49678756b6480245566c"
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
