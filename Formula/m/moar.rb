class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.31.8.tar.gz"
  sha256 "77943278d1ca22c3ca405c6a227e4807ce8637b807c40802c739f901ae980151"
  license "BSD-2-Clause"
  head "https://github.com/walles/moar.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74f3aef825a2aa81f295e76fe44a864957893f94bfc657ac361a99fc802a0c7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74f3aef825a2aa81f295e76fe44a864957893f94bfc657ac361a99fc802a0c7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74f3aef825a2aa81f295e76fe44a864957893f94bfc657ac361a99fc802a0c7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "43d44b9b46166a61b43eca3e56b211177f4ced4fe6f2b67f12d1348dd38e66b9"
    sha256 cellar: :any_skip_relocation, ventura:       "43d44b9b46166a61b43eca3e56b211177f4ced4fe6f2b67f12d1348dd38e66b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fa98a9e995931f01a6923ef071ca482945d39751f7d053dd704d8fc0a235248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc6507eaa8a76ff71b0f32cdb2aaaba574bc1212cc6bc2bd8b0a18883e9894a"
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
