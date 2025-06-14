class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.31.10.tar.gz"
  sha256 "e15c301e7ee2a30407dad6941166260da233475d1058b60e8c8d07c6e65de92b"
  license "BSD-2-Clause"
  head "https://github.com/walles/moar.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0258e92afafd77ef55c25e956744164ac4c9816885c23f085ac27ba99cc489c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0258e92afafd77ef55c25e956744164ac4c9816885c23f085ac27ba99cc489c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0258e92afafd77ef55c25e956744164ac4c9816885c23f085ac27ba99cc489c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd97114ef494fb5209ded1d0b784264450e67668e747e1e73a15f3e3c414d643"
    sha256 cellar: :any_skip_relocation, ventura:       "fd97114ef494fb5209ded1d0b784264450e67668e747e1e73a15f3e3c414d643"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13ed078c45e6e3f4c53a4d37026eff51ba2f14f7c33b71e23d7e1869f9769133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dca26758eca58fd294c34c99fe7cc8263a689bc5caf141af073bd1437fd995b2"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
