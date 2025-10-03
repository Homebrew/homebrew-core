class Bgrep < Formula
  desc "Like grep but for binary strings"
  homepage "https://github.com/tmbinc/bgrep"
  url "https://github.com/tmbinc/bgrep/archive/refs/tags/bgrep-0.2.tar.gz"
  sha256 "24c02393fb436d7a2eb02c6042ec140f9502667500b13a59795388c1af91f9ba"
  license "BSD-2-Clause"
  head "https://github.com/tmbinc/bgrep.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "cb6e6a68d53feffbff679a734db6345a373556ddd3f2d76e2f073b4d3f84d452"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e9084b991c90bd70740bce59c399d55365789b5226d8883067f552d2601fa0b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2246a9bc12ae07c1c2403b4efb0023bc96c22867bff0ad41d1d7381ef5b694a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b808abe4e0fd7be98cd1d9916c7e839f95cb086d28a987101aa51a73c22da87f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c65ddc4ca486db177cd63f45e4cb97172f590ed9b2f70364120b2326e7ab3f94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d5628a1b93a4ad2e770502b011140bc301051e1679ac5d59eadbd9b94944b1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c1b6ebd1db5456a5df3a9d7c6c3f5f360bc1a717c0428d204670f7c2e070210"
    sha256 cellar: :any_skip_relocation, ventura:        "0240d1970176f07cb0649f1da10501aadd49ca7a915756ecadb0d08fb1032bb5"
    sha256 cellar: :any_skip_relocation, monterey:       "2264b9b3c17b3faa5c66f612ce460a65e02bf0f3c3620002c90866c699b5cf81"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbd5d550e042d764f0cc4c39e58cd40ae87430fb773aae7d77f3ca56d05c3325"
    sha256 cellar: :any_skip_relocation, catalina:       "444a8dd0c2190e3a75574f8bee287895aee1d070d3e72e72fd7cda4c9cb77211"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9d285a3edc43fe8730ff6c744018cbbea2562647ff97565f8cc0b5c75d565e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5a19c037fcdd2ef3d50b419dd0d80208febfe24fb6bf785f40f47b7b2f87f45"
  end

  def install
    args = %w[bgrep.c -o bgrep]
    args << ENV.cflags if ENV.cflags.present?
    system ENV.cc, *args
    bin.install "bgrep"
  end

  test do
    path = testpath/"hi.prg"
    path.binwrite [0x00, 0xc0, 0xa9, 0x48, 0x20, 0xd2, 0xff,
                   0xa9, 0x49, 0x20, 0xd2, 0xff, 0x60].pack("C*")

    assert_equal "#{path}: 00000004\n#{path}: 00000009\n",
                 shell_output("#{bin}/bgrep 20d2ff #{path}")
  end
end
