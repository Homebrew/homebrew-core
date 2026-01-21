class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "3879b97672bc67a421724f7c49ee72dce60574330744965455d214b1ab535a4c"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b19966bdf215401f6450567411776b53984c97db7dfb3b339bd8420589beb93a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b19966bdf215401f6450567411776b53984c97db7dfb3b339bd8420589beb93a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b19966bdf215401f6450567411776b53984c97db7dfb3b339bd8420589beb93a"
    sha256 cellar: :any_skip_relocation, sonoma:        "22133d0f04e2f9f427cde12072c8e97502ccf1f1ae7e09041122f7f4dbdccd07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd49bf9be813ace57173c713de5947d73fe9dd1773c3527a3923df74ab410728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5515f034e0c695a73bf9f0bb98159fb94d33fc4c58b9474aa32831582200e28"
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
