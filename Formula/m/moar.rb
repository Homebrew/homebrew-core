class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.18.6.tar.gz"
  sha256 "0a9143be12f6848750bdd77b2bd5d71c5b46e0d98d9987970b5c9ace8133f888"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28e081a54c9ceb50f5666c1d8eddee5bb8343957adbdea614f08e365f81cbdb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28e081a54c9ceb50f5666c1d8eddee5bb8343957adbdea614f08e365f81cbdb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28e081a54c9ceb50f5666c1d8eddee5bb8343957adbdea614f08e365f81cbdb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "dec2ed3d36e6d1ed86eaf53e942ea28bbd474a430a2ce62c35b79b410f2a49dc"
    sha256 cellar: :any_skip_relocation, ventura:        "dec2ed3d36e6d1ed86eaf53e942ea28bbd474a430a2ce62c35b79b410f2a49dc"
    sha256 cellar: :any_skip_relocation, monterey:       "dec2ed3d36e6d1ed86eaf53e942ea28bbd474a430a2ce62c35b79b410f2a49dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca9f824495ec8a68cec3500ee44faf1e0dc81eff0c0741718d0000858570b5b6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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
