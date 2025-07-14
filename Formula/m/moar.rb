class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.32.3.tar.gz"
  sha256 "5bb5906ae3d6e03e092ed63e862385e77d35875fc2cae761eee835c754814400"
  license "BSD-2-Clause"
  head "https://github.com/walles/moar.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb7742d96bf9b287e1eba036f277031bd82ef5b71f8329da90e7d2dacad48e45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb7742d96bf9b287e1eba036f277031bd82ef5b71f8329da90e7d2dacad48e45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb7742d96bf9b287e1eba036f277031bd82ef5b71f8329da90e7d2dacad48e45"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0ac6b4ad488d95e2a9aa930ce528dbb75dea9107bce7d34eb474c29cd2b507e"
    sha256 cellar: :any_skip_relocation, ventura:       "c0ac6b4ad488d95e2a9aa930ce528dbb75dea9107bce7d34eb474c29cd2b507e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e01ebca6125665cd345b9bfc11664ef51c3af39931b87dd9ec61a21f3df9be1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbef40efa108865b660d2323138733b6c783979e39f246b0b9f69b2587e78895"
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
